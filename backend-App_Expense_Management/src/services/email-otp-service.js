const bcrypt = require("bcrypt");
const env = require("../config/env");
const { readOtpRecords, writeOtpRecords } = require("../repositories/otp-repository");
const { readUsers, writeUsers } = require("../repositories/user-repository");
const { sendOtpEmail } = require("./email-service");
const { registerWithPassword } = require("./auth-service");

function isEmailLike(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value || "").trim());
}

function generateOtpCode() {
  return String(Math.floor(100000 + Math.random() * 900000));
}

function recordKey(email, purpose) {
  return `${purpose}:${email.toLowerCase()}`;
}

async function requestEmailOtp(emailRaw, purposeRaw) {
  const email = String(emailRaw || "").trim().toLowerCase();
  const purpose = String(purposeRaw || "").trim().toLowerCase();

  if (!isEmailLike(email)) {
    return { status: 400, body: { message: "Email is invalid" } };
  }
  if (purpose !== "register" && purpose !== "reset") {
    return { status: 400, body: { message: "Purpose must be register or reset" } };
  }

  const users = await readUsers();
  const existingUser = users.find((u) => String(u.identifierLower || u.usernameLower || "") === email);

  if (purpose === "register" && existingUser) {
    return { status: 409, body: { message: "Email already exists" } };
  }

  if (purpose === "reset") {
    if (!existingUser) {
      return { status: 404, body: { message: "Email not found" } };
    }
    if (!existingUser.passwordHash) {
      return {
        status: 400,
        body: { message: "This account uses OAuth only. Please login with provider." },
      };
    }
  }

  const records = await readOtpRecords();
  const key = recordKey(email, purpose);
  const now = Date.now();
  const resendCooldownMs = env.otpResendCooldownSeconds * 1000;
  const current = records.find((r) => r.key === key);

  if (current && now - Number(current.requestedAt || 0) < resendCooldownMs) {
    const waitSeconds = Math.ceil((resendCooldownMs - (now - Number(current.requestedAt || 0))) / 1000);
    return {
      status: 429,
      body: { message: `Please wait ${waitSeconds}s before requesting a new code` },
    };
  }

  const code = generateOtpCode();
  const codeHash = await bcrypt.hash(code, 10);
  const expiresAt = now + env.otpExpiresMinutes * 60 * 1000;

  const nextRecords = records.filter((r) => r.key !== key);
  nextRecords.push({
    key,
    purpose,
    email,
    codeHash,
    requestedAt: now,
    expiresAt,
  });
  await writeOtpRecords(nextRecords);

  const mailResult = await sendOtpEmail({ toEmail: email, code, purpose });

  if (!mailResult.sent) {
    return {
      status: 200,
      body: {
        message: "OTP created but email sender is not configured",
        sent: false,
        debugCode: env.nodeEnv === "development" ? code : undefined,
      },
    };
  }

  return {
    status: 200,
    body: {
      message: "OTP sent to email",
      sent: true,
      debugCode: env.nodeEnv === "development" ? code : undefined,
    },
  };
}

async function verifyRegisterEmailOtp({ emailRaw, codeRaw, passwordRaw, displayNameRaw }) {
  const email = String(emailRaw || "").trim().toLowerCase();
  const code = String(codeRaw || "").trim();
  const password = String(passwordRaw || "").trim();
  const displayName = String(displayNameRaw || "").trim();

  if (!isEmailLike(email)) {
    return { status: 400, body: { message: "Email is invalid" } };
  }
  if (!/^\d{6}$/.test(code)) {
    return { status: 400, body: { message: "OTP must be 6 digits" } };
  }

  const records = await readOtpRecords();
  const key = recordKey(email, "register");
  const record = records.find((r) => r.key === key);

  if (!record) {
    return { status: 400, body: { message: "OTP not found. Please request a new code" } };
  }
  if (Date.now() > Number(record.expiresAt || 0)) {
    return { status: 400, body: { message: "OTP has expired" } };
  }

  const ok = await bcrypt.compare(code, String(record.codeHash || ""));
  if (!ok) {
    return { status: 401, body: { message: "OTP is incorrect" } };
  }

  const registerResult = await registerWithPassword(email, password, displayName);
  if (!registerResult.user) {
    return registerResult;
  }

  await writeOtpRecords(records.filter((r) => r.key !== key));
  return registerResult;
}

async function verifyResetEmailOtp({ emailRaw, codeRaw, newPasswordRaw }) {
  const email = String(emailRaw || "").trim().toLowerCase();
  const code = String(codeRaw || "").trim();
  const newPassword = String(newPasswordRaw || "").trim();

  if (!isEmailLike(email)) {
    return { status: 400, body: { message: "Email is invalid" } };
  }
  if (!/^\d{6}$/.test(code)) {
    return { status: 400, body: { message: "OTP must be 6 digits" } };
  }
  if (newPassword.length < 6) {
    return { status: 400, body: { message: "Password must have at least 6 characters" } };
  }

  const records = await readOtpRecords();
  const key = recordKey(email, "reset");
  const record = records.find((r) => r.key === key);

  if (!record) {
    return { status: 400, body: { message: "OTP not found. Please request a new code" } };
  }
  if (Date.now() > Number(record.expiresAt || 0)) {
    return { status: 400, body: { message: "OTP has expired" } };
  }

  const ok = await bcrypt.compare(code, String(record.codeHash || ""));
  if (!ok) {
    return { status: 401, body: { message: "OTP is incorrect" } };
  }

  const users = await readUsers();
  const user = users.find((u) => String(u.identifierLower || u.usernameLower || "") === email);
  if (!user) {
    return { status: 404, body: { message: "Email not found" } };
  }

  user.passwordHash = await bcrypt.hash(newPassword, 10);
  await writeUsers(users);
  await writeOtpRecords(records.filter((r) => r.key !== key));

  return {
    status: 200,
    body: {
      message: "Password reset success",
    },
  };
}

module.exports = {
  requestEmailOtp,
  verifyRegisterEmailOtp,
  verifyResetEmailOtp,
};
