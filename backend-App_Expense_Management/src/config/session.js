const session = require("express-session");
const env = require("./env");

function sessionMiddleware() {
  return session({
    name: "expense.sid",
    secret: env.sessionSecret,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      secure: env.nodeEnv === "production",
      sameSite: "lax",
      maxAge: 1000 * 60 * 60 * 24 * 7,
    },
  });
}

module.exports = sessionMiddleware;
