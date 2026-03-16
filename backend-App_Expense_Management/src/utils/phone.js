function normalizePhoneToE164VN(raw) {
  const value = String(raw || '').trim();
  if (!value) {
    return null;
  }

  if (/^\+\d{8,15}$/.test(value)) {
    return value;
  }

  const digits = value.replace(/\D/g, '');
  if (!digits) {
    return null;
  }

  if (digits.startsWith('84') && digits.length >= 10 && digits.length <= 11) {
    return `+${digits}`;
  }

  if (digits.startsWith('0') && digits.length == 10) {
    return `+84${digits.slice(1)}`;
  }

  if (digits.length == 9) {
    return `+84${digits}`;
  }

  return null;
}

module.exports = {
  normalizePhoneToE164VN,
};
