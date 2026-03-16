const { admin, initFirebaseAdmin } = require('../config/firebase-admin');
const { normalizePhoneToE164VN } = require('../utils/phone');

function isEmailLike(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value || '').trim());
}

async function upsertFirebaseUserFromLocal(localUser) {
  if (!initFirebaseAdmin()) {
    return { synced: false, reason: 'firebase-not-configured' };
  }

  const uid = String(localUser.id || '').trim();
  if (!uid) {
    return { synced: false, reason: 'missing-uid' };
  }

  const identifier = String(localUser.identifier || localUser.username || '').trim();
  const displayName = String(localUser.displayName || identifier || '').trim();
  const phoneNumber = normalizePhoneToE164VN(identifier);
  const email = isEmailLike(identifier) ? identifier.toLowerCase() : undefined;

  const payload = {
    uid,
    displayName: displayName || undefined,
  };

  if (phoneNumber) {
    payload.phoneNumber = phoneNumber;
  }
  if (email) {
    payload.email = email;
    payload.emailVerified = false;
  }

  // Do not create Firebase users without a usable login identifier.
  if (!payload.email && !payload.phoneNumber) {
    return {
      synced: false,
      reason: 'invalid-identifier',
      detail: 'Identifier must be a valid email or phone number',
    };
  }

  try {
    await admin.auth().getUser(uid);
    await admin.auth().updateUser(uid, payload);
    return { synced: true, operation: 'update' };
  } catch (error) {
    if (error?.code === 'auth/user-not-found') {
      try {
        await admin.auth().createUser(payload);
        return { synced: true, operation: 'create' };
      } catch (createError) {
        return {
          synced: false,
          reason: 'create-failed',
          error: String(createError),
        };
      }
    }

    return {
      synced: false,
      reason: 'update-failed',
      error: String(error),
    };
  }
}

module.exports = {
  upsertFirebaseUserFromLocal,
};
