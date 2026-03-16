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
};

module.exports = env;
