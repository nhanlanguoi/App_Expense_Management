const nodemailer = require("nodemailer");
const env = require("../config/env");

let cachedTransporter = null;

function getTransporter() {
  if (cachedTransporter) {
    return cachedTransporter;
  }

  if (!env.mailUser || !env.mailAppPassword) {
    return null;
  }

  cachedTransporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: env.mailUser,
      pass: env.mailAppPassword,
    },
  });

  return cachedTransporter;
}

function buildOtpHtml({ code, purpose }) {
  const actionText = purpose === "register" ? "xac thuc tai khoan" : "dat lai mat khau";

  return `
  <div style="font-family: Arial, sans-serif; color: #1f2937; line-height: 1.6;">
    <h2 style="margin-bottom: 8px;">Expense Management</h2>
    <p>Ma OTP de ${actionText} cua ban la:</p>
    <p style="font-size: 28px; letter-spacing: 8px; font-weight: 700; color: #6d28d9;">${code}</p>
    <p>Ma co hieu luc trong ${env.otpExpiresMinutes} phut.</p>
    <p>Neu ban khong thuc hien yeu cau nay, vui long bo qua email.</p>
  </div>`;
}

async function sendOtpEmail({ toEmail, code, purpose }) {
  const transporter = getTransporter();
  if (!transporter) {
    return { sent: false, reason: "mail-not-configured" };
  }

  const from = env.mailFrom || env.mailUser;
  const subject =
    purpose === "register"
      ? "[Expense Management] Ma OTP xac thuc tai khoan"
      : "[Expense Management] Ma OTP dat lai mat khau";

  await transporter.sendMail({
    from,
    to: toEmail,
    subject,
    html: buildOtpHtml({ code, purpose }),
  });

  return { sent: true };
}

module.exports = {
  sendOtpEmail,
};
