const fs = require("fs/promises");
const env = require("../config/env");

async function ensureUsersStore() {
  await fs.mkdir(env.dataDir, { recursive: true });
  try {
    await fs.access(env.usersFile);
  } catch {
    await fs.writeFile(env.usersFile, "[]", "utf8");
  }
}

async function readUsers() {
  await ensureUsersStore();
  const raw = await fs.readFile(env.usersFile, "utf8");
  const users = JSON.parse(raw);
  return Array.isArray(users) ? users : [];
}

async function writeUsers(users) {
  await fs.writeFile(env.usersFile, JSON.stringify(users, null, 2), "utf8");
}

module.exports = {
  ensureUsersStore,
  readUsers,
  writeUsers,
};
