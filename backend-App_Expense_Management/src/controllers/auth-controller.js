const {
  registerWithPassword,
  loginWithPassword,
  loginWithFirebaseToken,
  getCurrentUserById,
} = require("../services/auth-service");

async function register(req, res) {
  try {
    const result = await registerWithPassword(req.body?.username, req.body?.password);
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(500).json({ message: "Register failed", error: String(error) });
  }
}

async function login(req, res) {
  try {
    const result = await loginWithPassword(req.body?.username, req.body?.password);
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(500).json({ message: "Login failed", error: String(error) });
  }
}

async function firebaseLogin(req, res) {
  try {
    const result = await loginWithFirebaseToken(req.body?.idToken);
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(401).json({
      message: "Invalid Firebase token",
      error: String(error),
    });
  }
}

function logout(req, res) {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ message: "Logout failed" });
    }
    return res.json({ message: "Logout success" });
  });
}

async function me(req, res) {
  try {
    const user = await getCurrentUserById(req.session.userId);
    if (!user) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    return res.json({ user });
  } catch (error) {
    return res.status(500).json({ message: "Cannot get current user", error: String(error) });
  }
}

module.exports = {
  register,
  login,
  firebaseLogin,
  logout,
  me,
};
