const path = require("path");
require("dotenv").config();

const env = {
  port: Number(process.env.PORT || 3000),
  nodeEnv: process.env.NODE_ENV || "development",
  sessionSecret: process.env.SESSION_SECRET || "expense-management-dev-secret",
  corsOrigin: process.env.CORS_ORIGIN || true,
  dataDir: path.join(__dirname, "../../data"),
  usersFile: path.join(__dirname, "../../data/users.json"),
  firebaseServiceAccountJson: process.env.FIREBASE_SERVICE_ACCOUNT_JSON,
  googleApplicationCredentials: process.env.GOOGLE_APPLICATION_CREDENTIALS,
  mailUser: process.env.MAIL_USER,
  mailAppPassword: process.env.MAIL_APP_PASSWORD,
  mailFrom: process.env.MAIL_FROM,
  otpExpiresMinutes: Number(process.env.OTP_EXPIRES_MINUTES || 10),
  otpResendCooldownSeconds: Number(process.env.OTP_RESEND_COOLDOWN_SECONDS || 60),
  otpFile: path.join(__dirname, "../../data/email-otp.json"),
};

module.exports = env;
