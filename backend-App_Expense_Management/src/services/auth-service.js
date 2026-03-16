const bcrypt = require("bcrypt");
const { randomUUID } = require("crypto");
const { admin, initFirebaseAdmin } = require("../config/firebase-admin");
const { readUsers, writeUsers } = require("../repositories/user-repository");

function sanitizeUser(user) {
  return {
    id: user.id,
    username: user.username,
    authProvider: user.authProvider || "local",
    firebaseUid: user.firebaseUid || null,
    createdAt: user.createdAt,
  };
}

function buildOAuthUsername(users, decodedToken) {
  const baseRaw = decodedToken.name || decodedToken.email || `user_${decodedToken.uid.slice(0, 6)}`;
  const safeBase = String(baseRaw)
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9_]/g, "_")
    .replace(/_+/g, "_")
    .replace(/^_+|_+$/g, "")
    .slice(0, 24);

  const base = safeBase.length >= 3 ? safeBase : `user_${decodedToken.uid.slice(0, 6)}`;
  let candidate = base;
  let count = 1;

  while (users.some((u) => u.usernameLower === candidate.toLowerCase())) {
    candidate = `${base}_${count}`;
    count += 1;
  }

  return candidate;
}

async function registerWithPassword(usernameRaw, passwordRaw) {
  const username = String(usernameRaw || "").trim();
  const password = String(passwordRaw || "").trim();

  if (username.length < 3) {
    return { status: 400, body: { message: "Username must have at least 3 characters" } };
  }

  if (password.length < 6) {
    return { status: 400, body: { message: "Password must have at least 6 characters" } };
  }

  const users = await readUsers();
  const usernameLower = username.toLowerCase();
  const existed = users.find((u) => u.usernameLower === usernameLower);
  if (existed) {
    return { status: 409, body: { message: "Username already exists" } };
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const user = {
    id: randomUUID(),
    username,
    usernameLower,
    passwordHash,
    createdAt: new Date().toISOString(),
  };

  users.push(user);
  await writeUsers(users);

  return {
    status: 201,
    body: {
      message: "Register success",
      user: sanitizeUser(user),
    },
    user,
  };
}

async function loginWithPassword(usernameRaw, passwordRaw) {
  const username = String(usernameRaw || "").trim();
  const password = String(passwordRaw || "").trim();

  if (!username || !password) {
    return { status: 400, body: { message: "Username and password are required" } };
  }

  const users = await readUsers();
  const usernameLower = username.toLowerCase();
  const user = users.find((u) => u.usernameLower === usernameLower);
  if (!user) {
    return { status: 401, body: { message: "Invalid username or password" } };
  }

  if (!user.passwordHash) {
    return {
      status: 400,
      body: { message: "This account uses OAuth. Please login with Google/Facebook." },
    };
  }

  const ok = await bcrypt.compare(password, user.passwordHash);
  if (!ok) {
    return { status: 401, body: { message: "Invalid username or password" } };
  }

  return {
    status: 200,
    body: {
      message: "Login success",
      user: sanitizeUser(user),
    },
    user,
  };
}

async function loginWithFirebaseToken(idTokenRaw) {
  if (!initFirebaseAdmin()) {
    return { status: 503, body: { message: "Firebase is not configured on server" } };
  }

  const idToken = String(idTokenRaw || "").trim();
  if (!idToken) {
    return { status: 400, body: { message: "idToken is required" } };
  }

  const decodedToken = await admin.auth().verifyIdToken(idToken, true);
  const firebaseUid = decodedToken.uid;
  const authProvider = decodedToken.firebase?.sign_in_provider || "firebase";

  if (authProvider !== "google.com" && authProvider !== "facebook.com") {
    return {
      status: 400,
      body: { message: "Only Google and Facebook OAuth are allowed in this endpoint" },
    };
  }

  const users = await readUsers();
  let user = users.find((u) => u.firebaseUid === firebaseUid);

  if (!user) {
    const username = buildOAuthUsername(users, decodedToken);
    user = {
      id: randomUUID(),
      username,
      usernameLower: username.toLowerCase(),
      authProvider,
      firebaseUid,
      email: decodedToken.email || null,
      createdAt: new Date().toISOString(),
    };
    users.push(user);
  } else {
    user.authProvider = authProvider;
    user.email = decodedToken.email || user.email || null;
  }

  await writeUsers(users);

  return {
    status: 200,
    body: {
      message: "Firebase OAuth login success",
      user: sanitizeUser(user),
    },
    user,
  };
}

async function getCurrentUserById(userId) {
  const users = await readUsers();
  const user = users.find((u) => u.id === userId);
  if (!user) {
    return null;
  }
  return sanitizeUser(user);
}

module.exports = {
  registerWithPassword,
  loginWithPassword,
  loginWithFirebaseToken,
  getCurrentUserById,
};
