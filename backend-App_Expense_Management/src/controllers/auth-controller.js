const {
  registerWithPassword,
  loginWithPassword,
  loginWithFirebaseToken,
  getCurrentUserById,
} = require("../services/auth-service");
const {
  requestEmailOtp,
  verifyRegisterEmailOtp,
  verifyResetEmailOtp,
} = require("../services/email-otp-service");

async function register(req, res) {
  try {
    const result = await registerWithPassword(
      req.body?.identifier || req.body?.username,
      req.body?.password,
      req.body?.displayName,
    );
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
    const result = await loginWithPassword(req.body?.identifier || req.body?.username, req.body?.password);
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
    const detail = String(error?.message || error || "Unknown error");
    return res.status(401).json({
      message: `Invalid Firebase token: ${detail}`,
      error: detail,
    });
  }
}

async function googleLogin(req, res) {
  try {
    const result = await loginWithFirebaseToken(req.body?.idToken);
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(401).json({
      message: "Invalid Google token",
      error: String(error),
    });
  }
}

async function facebookLogin(req, res) {
  try {
    const result = await loginWithFirebaseToken(req.body?.idToken);
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(401).json({
      message: "Invalid Facebook token",
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

async function requestOtp(req, res) {
  try {
    const result = await requestEmailOtp(req.body?.email, req.body?.purpose);
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(500).json({ message: "Request OTP failed", error: String(error) });
  }
}

async function verifyRegisterOtp(req, res) {
  try {
    const result = await verifyRegisterEmailOtp({
      emailRaw: req.body?.email,
      codeRaw: req.body?.code,
      passwordRaw: req.body?.password,
      displayNameRaw: req.body?.displayName,
    });
    if (result.user) {
      req.session.userId = result.user.id;
    }
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(500).json({ message: "Verify register OTP failed", error: String(error) });
  }
}

async function verifyResetOtp(req, res) {
  try {
    const result = await verifyResetEmailOtp({
      emailRaw: req.body?.email,
      codeRaw: req.body?.code,
      newPasswordRaw: req.body?.newPassword,
    });
    return res.status(result.status).json(result.body);
  } catch (error) {
    return res.status(500).json({ message: "Verify reset OTP failed", error: String(error) });
  }
}

module.exports = {
  register,
  login,
  firebaseLogin,
  googleLogin,
  facebookLogin,
  logout,
  me,
  requestOtp,
  verifyRegisterOtp,
  verifyResetOtp,
};
