const fs = require("fs/promises");
const env = require("../config/env");

async function ensureOtpStore() {
  await fs.mkdir(env.dataDir, { recursive: true });
  try {
    await fs.access(env.otpFile);
  } catch {
    await fs.writeFile(env.otpFile, "[]", "utf8");
  }
}

async function readOtpRecords() {
  await ensureOtpStore();
  const raw = await fs.readFile(env.otpFile, "utf8");
  const records = JSON.parse(raw);
  return Array.isArray(records) ? records : [];
}

async function writeOtpRecords(records) {
  await ensureOtpStore();
  await fs.writeFile(env.otpFile, JSON.stringify(records, null, 2), "utf8");
}

module.exports = {
  ensureOtpStore,
  readOtpRecords,
  writeOtpRecords,
};
