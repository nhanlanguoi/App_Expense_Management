const admin = require("firebase-admin");
const env = require("./env");

let firebaseReady = false;

function initFirebaseAdmin() {
  if (firebaseReady) {
    return true;
  }

  if (!env.firebaseServiceAccountJson && !env.googleApplicationCredentials) {
    return false;
  }

  try {
    if (admin.apps.length === 0) {
      if (env.firebaseServiceAccountJson) {
        const serviceAccount = JSON.parse(env.firebaseServiceAccountJson);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
      } else {
        admin.initializeApp({
          credential: admin.credential.applicationDefault(),
        });
      }
    }

    firebaseReady = true;
    return true;
  } catch (error) {
    console.error("Firebase Admin init failed", error);
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
