const bcrypt = require("bcrypt");
const { randomUUID } = require("crypto");
const { admin, initFirebaseAdmin } = require("../config/firebase-admin");
const { readUsers, writeUsers } = require("../repositories/user-repository");
const { upsertFirebaseUserFromLocal } = require("./firebase-user-sync-service");
const { normalizePhoneToE164VN } = require("../utils/phone");

function isEmailLike(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value || "").trim());
}

function normalizeIdentifier(raw) {
  const value = String(raw || "").trim();
  if (!value) {
    return null;
  }

  if (isEmailLike(value)) {
    return value.toLowerCase();
  }

  return normalizePhoneToE164VN(value);
}

function getUserIdentifier(user) {
  return String(user.identifier || user.username || "").trim();
}

function getUserIdentifierLower(user) {
  const stored = String(user.identifierLower || "").trim();
  if (stored) {
    return stored;
  }
  const normalized = normalizeIdentifier(getUserIdentifier(user));
  return normalized ? normalized.toLowerCase() : "";
}

function sanitizeUser(user) {
  const identifier = getUserIdentifier(user);
  return {
    id: user.id,
    identifier,
    username: user.username || identifier,
    displayName: user.displayName || user.username || identifier,
    email: user.email || (isEmailLike(identifier) ? identifier : null),
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

async function registerWithPassword(identifierRaw, passwordRaw, displayNameRaw) {
  const identifier = normalizeIdentifier(identifierRaw);
  const password = String(passwordRaw || "").trim();
  const displayName = String(displayNameRaw || "").trim();

  if (!identifier) {
    return {
      status: 400,
      body: { message: "Identifier must be a valid email or phone number" },
    };
  }

  if (password.length < 6) {
    return { status: 400, body: { message: "Password must have at least 6 characters" } };
  }

  const users = await readUsers();
  const identifierLower = identifier.toLowerCase();
  const existed = users.find((u) => getUserIdentifierLower(u) === identifierLower);
  if (existed) {
    return { status: 409, body: { message: "Email or phone already exists" } };
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const user = {
    id: randomUUID(),
    identifier,
    identifierLower,
    username: identifier,
    usernameLower: identifierLower,
    displayName: displayName || identifier,
    email: isEmailLike(identifier) ? identifier : null,
    passwordHash,
    createdAt: new Date().toISOString(),
  };

  users.push(user);
  await writeUsers(users);

  const firebaseSync = await upsertFirebaseUserFromLocal(user);

  return {
    status: 201,
    body: {
      message: "Register success",
      user: sanitizeUser(user),
      firebaseSync,
    },
    user,
  };
}

async function loginWithPassword(identifierRaw, passwordRaw) {
  const identifier = normalizeIdentifier(identifierRaw);
  const password = String(passwordRaw || "").trim();

  if (!identifier || !password) {
    return { status: 400, body: { message: "Email/phone and password are required" } };
  }

  const users = await readUsers();
  const identifierLower = identifier.toLowerCase();
  const user = users.find((u) => getUserIdentifierLower(u) === identifierLower);
  if (!user) {
    return { status: 401, body: { message: "Invalid email/phone or password" } };
  }

  if (!user.passwordHash) {
    return {
      status: 400,
      body: { message: "This account uses OAuth. Please login with Google/Facebook." },
    };
  }

  const ok = await bcrypt.compare(password, user.passwordHash);
  if (!ok) {
    return { status: 401, body: { message: "Invalid email/phone or password" } };
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

async function loginWithFirebaseToken(idTokenRaw, expectedProvider) {
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
  const genericAllowedProviders = ["google.com", "facebook.com", "password"];

  if (!expectedProvider && !genericAllowedProviders.includes(authProvider)) {
    return {
      status: 400,
      body: { message: "Unsupported Firebase sign-in provider" },
    };
  }

  if (expectedProvider && authProvider !== expectedProvider) {
    const providerName = expectedProvider === "google.com" ? "Google" : "Facebook";
    return {
      status: 400,
      body: {
        message: `This endpoint only accepts ${providerName} token`,
      },
    };
  }

  const users = await readUsers();
  let user = users.find((u) => u.firebaseUid === firebaseUid);
  const oauthDisplayName = String(decodedToken.name || "").trim();
  const oauthIdentifier = decodedToken.email ? String(decodedToken.email).toLowerCase() : null;

  if (!user) {
    const username = buildOAuthUsername(users, decodedToken);
    user = {
      id: randomUUID(),
      identifier: oauthIdentifier,
      identifierLower: oauthIdentifier,
      username,
      displayName: oauthDisplayName || username,
      usernameLower: username.toLowerCase(),
      authProvider,
      firebaseUid,
      email: decodedToken.email || null,
      createdAt: new Date().toISOString(),
    };
    users.push(user);
  } else {
    user.authProvider = authProvider;
    if (oauthDisplayName) {
      user.displayName = oauthDisplayName;
    }
    if (oauthIdentifier) {
      user.identifier = oauthIdentifier;
      user.identifierLower = oauthIdentifier;
    }
    user.email = decodedToken.email || user.email || null;
  }

  await writeUsers(users);

  return {
    status: 200,
    body: {
      message: "Firebase login success",
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
