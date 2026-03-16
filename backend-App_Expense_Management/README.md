# backend-App_Expense_Management

## P1 + P2 Auth (Session + Firebase OAuth)

This backend currently supports:

- Username/password auth with session cookie
- Google login via `POST /auth/google`
- Facebook login via `POST /auth/facebook`
- Generic Firebase OAuth login via `POST /auth/firebase`

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

- `POST /auth/register` with body `{ "username": "...", "password": "..." }`
- `POST /auth/login` with body `{ "username": "...", "password": "..." }`
- `POST /auth/google` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `POST /auth/facebook` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `POST /auth/firebase` with body `{ "idToken": "FIREBASE_ID_TOKEN" }`
- `GET /auth/me`
- `POST /auth/logout`

## Firebase Console Setup Guide

### A. Create Firebase project

1. Open Firebase Console.
2. Create a project (or use existing one).
3. In `Project settings > General`, note project id.

### B. Enable Authentication providers

1. Go to `Authentication > Sign-in method`.
2. Enable `Google` provider.
3. Enable `Facebook` provider:
	- Enter App ID and App Secret from Meta for Developers.
	- Add OAuth redirect URI from Firebase screen to your Facebook app config.

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
