const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");
const env = require("./env");

let firebaseReady = false;

function resolveServiceAccountPath() {
  if (env.googleApplicationCredentials) {
    return path.isAbsolute(env.googleApplicationCredentials)
      ? env.googleApplicationCredentials
      : path.resolve(path.join(__dirname, "../../", env.googleApplicationCredentials));
  }

  // Default local key file in backend root.
  return path.join(
    __dirname,
    "../../app-expense-management-firebase-adminsdk-fbsvc-b603707cfe.json",
  );
}

function initFirebaseAdmin() {
  if (firebaseReady) {
    return true;
  }

  try {
    if (admin.apps.length === 0) {
      const serviceAccountPath = resolveServiceAccountPath();
      if (!fs.existsSync(serviceAccountPath)) {
        throw new Error(`Service account file not found at: ${serviceAccountPath}`);
      }

      // Load JSON key file directly as requested.
      const serviceAccount = require(serviceAccountPath);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    }

    firebaseReady = true;
    return true;
  } catch (error) {
    console.error("Firebase Admin init failed", {
      message: String(error?.message || error),
      code: error?.code || null,
    });
    return false;
  }
}

function isFirebaseReady() {
  return firebaseReady;
}

module.exports = {
  admin,
  initFirebaseAdmin,
  isFirebaseReady,
};
