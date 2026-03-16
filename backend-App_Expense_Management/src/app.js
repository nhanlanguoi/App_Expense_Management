const express = require("express");
const cors = require("cors");
const env = require("./config/env");
const sessionMiddleware = require("./config/session");
const authRoutes = require("./routes/auth-routes");

function createApp() {
  const app = express();

  app.use((req, _res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
    next();
  });

  app.use(
    cors({
      origin: env.corsOrigin,
      credentials: true,
    }),
  );

  app.use(express.json({ limit: "1mb" }));
  app.use(sessionMiddleware());

  app.get("/health", (_req, res) => {
    res.json({ ok: true });
  });

  app.use("/auth", authRoutes);

  return app;
}

module.exports = createApp;
