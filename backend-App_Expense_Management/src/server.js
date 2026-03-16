const env = require("./config/env");
const createApp = require("./app");
const { initFirebaseAdmin } = require("./config/firebase-admin");
const { ensureUsersStore } = require("./repositories/user-repository");

async function startServer() {
  await ensureUsersStore();
  const app = createApp();

  if (initFirebaseAdmin()) {
    console.log("Firebase Admin is ready");
  } else {
    console.log("Firebase Admin is not configured yet");
  }

  app.listen(env.port, () => {
    console.log(`Auth server is running at http://localhost:${env.port}`);
  });
}

startServer().catch((error) => {
  console.error("Failed to start server", error);
  process.exit(1);
});
