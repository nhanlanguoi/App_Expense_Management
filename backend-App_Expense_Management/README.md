# backend-App_Expense_Management

## P1 + P2 Auth (Session + Firebase OAuth)

This backend currently supports:

- Email/phone + password auth with session cookie
- Google login via `POST /auth/google`
- Facebook login via `POST /auth/facebook`
- Generic Firebase OAuth login via `POST /auth/firebase`
- Auto upsert registered form users to Firebase Auth Users (best effort)

## Quick Start

1. Copy `.env.example` to `.env` and fill values.
2. Install dependencies:

```bash
npm install
```

3. Run server:

```bash
npm run dev
```

## API

- `POST /auth/register` with body `{ "identifier": "email-or-phone", "password": "...", "displayName": "..." }`
- `POST /auth/login` with body `{ "identifier": "email-or-phone", "password": "..." }`
- `POST /auth/email-otp/request` with body `{ "email": "user@gmail.com", "purpose": "register|reset" }`
- `POST /auth/email-otp/verify-register` with body `{ "email": "user@gmail.com", "code": "123456", "password": "...", "displayName": "..." }`
- `POST /auth/email-otp/verify-reset` with body `{ "email": "user@gmail.com", "code": "123456", "newPassword": "..." }`
- `POST /auth/firebase` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `POST /auth/google` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `POST /auth/facebook` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `GET /auth/me`
- `POST /auth/logout`

## Email OTP notes

- OTP is only for email flow (register by email and forgot-password by email).
- Phone OTP is not implemented (no SMS service configured).
- If mail sender is not configured, API still creates OTP and returns `debugCode` in development mode.

## Firebase Console Setup Guide

### A. Create Firebase project

1. Open Firebase Console.
2. Create a project (or use existing one).
3. In `Project settings > General`, note project id.

### B. Enable Authentication providers

1. Go to `Authentication > Sign-in method`.
2. Enable `Email/Password` provider.
3. Enable `Google` provider.
4. Enable `Facebook` provider:
	- Enter App ID and App Secret from Meta for Developers.
	- Add OAuth redirect URI from Firebase screen to your Facebook app config.

### B2. Configure Firebase SMTP for outgoing emails

1. Go to `Authentication > Templates > SMTP settings`.
2. Turn on `Enable`.
3. Fill fields with your SMTP provider values:
	- Sender address: e.g. `support@yourdomain.com`
	- SMTP server host: e.g. `smtp.gmail.com`
	- SMTP server port: `587` (STARTTLS) or `465` (SSL/TLS)
	- SMTP account username/password: your SMTP credentials
	- SMTP security mode: `STARTTLS` (for 587) or `SSL` (for 465)
4. Save.
5. In `Templates`, edit `Email address verification` and `Password reset` content/language.

### C. Create service account for backend verification

1. Go to `Project settings > Service accounts`.
2. Click `Generate new private key`.
3. Download JSON key.
4. Configure backend with one option:
	- Put key JSON in `FIREBASE_SERVICE_ACCOUNT_JSON` as one-line string, or
	- Set `GOOGLE_APPLICATION_CREDENTIALS` to file path.

### D. Flutter login flow with this backend

1. User signs in with Firebase Auth (Google/Facebook) on Flutter.
2. Flutter gets ID token from Firebase user.
3. Flutter calls backend `POST /auth/firebase` with `{ idToken }`.
4. Backend verifies token and creates a session cookie.

## Notes

- This project intentionally uses session cookie only (no custom JWT refresh flow).
- OAuth accounts do not use local password in backend.
- `POST /auth/register` now includes `firebaseSync` in response body to indicate Firebase upsert status.
- Email register/login/reset now uses Firebase Auth email flow:
	- Register email: Firebase sends verification email.
	- Forgot password: Firebase sends password reset email.
	- After email is verified, app exchanges Firebase ID token with backend `/auth/firebase` to create backend session.
