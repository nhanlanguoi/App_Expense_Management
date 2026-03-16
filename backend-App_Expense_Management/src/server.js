const env = require("./config/env");
const createApp = require("./app");
const { initFirebaseAdmin } = require("./config/firebase-admin");
const { ensureUsersStore } = require("./repositories/user-repository");
const { ensureOtpStore } = require("./repositories/otp-repository");
const { ensureDefaultAdminAccount } = require("./services/auth-service");

async function startServer() {
  await ensureUsersStore();
  await ensureOtpStore();
  const seeded = await ensureDefaultAdminAccount();
  if (seeded) {
    console.log("Seeded default account: admin / 123");
  }
  const app = createApp();

  if (initFirebaseAdmin()) {
    console.log("Firebase Admin is ready");
  } else {
    console.log("Firebase Admin is not configured yet");
  }

  app.listen(env.port, "0.0.0.0", () => {
    console.log(`Auth server is running on port ${env.port} (host: 0.0.0.0)`);
  });
}

startServer().catch((error) => {
  console.error("Failed to start server", error);
  process.exit(1);
});
