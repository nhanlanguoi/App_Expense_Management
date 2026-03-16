const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const session = require("express-session");
const { randomUUID } = require("crypto");
const fs = require("fs/promises");
const path = require("path");
require("dotenv").config();

const app = express();
const PORT = Number(process.env.PORT || 3000);
const SESSION_SECRET = process.env.SESSION_SECRET || "expense-management-dev-secret";
const DATA_DIR = path.join(__dirname, "data");
const USERS_FILE = path.join(DATA_DIR, "users.json");

app.use(
	cors({
		origin: process.env.CORS_ORIGIN || true,
		credentials: true,
	}),
);
app.use(express.json({ limit: "1mb" }));
app.use(
	session({
		name: "expense.sid",
		secret: SESSION_SECRET,
		resave: false,
		saveUninitialized: false,
		cookie: {
			httpOnly: true,
			secure: process.env.NODE_ENV === "production",
			sameSite: "lax",
			maxAge: 1000 * 60 * 60 * 24 * 7,
		},
	}),
);

async function ensureUsersStore() {
	await fs.mkdir(DATA_DIR, { recursive: true });
	try {
		await fs.access(USERS_FILE);
	} catch {
		await fs.writeFile(USERS_FILE, "[]", "utf8");
	}
}

async function readUsers() {
	await ensureUsersStore();
	const raw = await fs.readFile(USERS_FILE, "utf8");
	const users = JSON.parse(raw);
	return Array.isArray(users) ? users : [];
}

async function writeUsers(users) {
	await fs.writeFile(USERS_FILE, JSON.stringify(users, null, 2), "utf8");
}

function sanitizeUser(user) {
	return {
		id: user.id,
		username: user.username,
		createdAt: user.createdAt,
	};
}

function requireAuth(req, res, next) {
	if (!req.session.userId) {
		return res.status(401).json({ message: "Unauthorized" });
	}
	return next();
}

app.get("/health", (_req, res) => {
	res.json({ ok: true });
});

app.post("/auth/register", async (req, res) => {
	try {
		const username = String(req.body?.username || "").trim();
		const password = String(req.body?.password || "").trim();

		if (username.length < 3) {
			return res.status(400).json({ message: "Username must have at least 3 characters" });
		}
		if (password.length < 6) {
			return res.status(400).json({ message: "Password must have at least 6 characters" });
		}

		const users = await readUsers();
		const usernameLower = username.toLowerCase();
		const existed = users.find((u) => u.usernameLower === usernameLower);
		if (existed) {
			return res.status(409).json({ message: "Username already exists" });
		}

		const passwordHash = await bcrypt.hash(password, 10);
		const newUser = {
			id: randomUUID(),
			username,
			usernameLower,
			passwordHash,
			createdAt: new Date().toISOString(),
		};

		users.push(newUser);
		await writeUsers(users);

		req.session.userId = newUser.id;

		return res.status(201).json({
			message: "Register success",
			user: sanitizeUser(newUser),
		});
	} catch (error) {
		return res.status(500).json({ message: "Register failed", error: String(error) });
	}
});

app.post("/auth/login", async (req, res) => {
	try {
		const username = String(req.body?.username || "").trim();
		const password = String(req.body?.password || "").trim();

		if (!username || !password) {
			return res.status(400).json({ message: "Username and password are required" });
		}

		const users = await readUsers();
		const usernameLower = username.toLowerCase();
		const user = users.find((u) => u.usernameLower === usernameLower);
		if (!user) {
			return res.status(401).json({ message: "Invalid username or password" });
		}

		const ok = await bcrypt.compare(password, user.passwordHash);
		if (!ok) {
			return res.status(401).json({ message: "Invalid username or password" });
		}

		req.session.userId = user.id;

		return res.json({
			message: "Login success",
			user: sanitizeUser(user),
		});
	} catch (error) {
		return res.status(500).json({ message: "Login failed", error: String(error) });
	}
});

app.post("/auth/logout", requireAuth, (req, res) => {
	req.session.destroy((err) => {
		if (err) {
			return res.status(500).json({ message: "Logout failed" });
		}
		return res.json({ message: "Logout success" });
	});
});

app.get("/auth/me", requireAuth, async (req, res) => {
	try {
		const users = await readUsers();
		const user = users.find((u) => u.id === req.session.userId);
		if (!user) {
			return res.status(401).json({ message: "Unauthorized" });
		}
		return res.json({ user: sanitizeUser(user) });
	} catch (error) {
		return res.status(500).json({ message: "Cannot get current user", error: String(error) });
	}
});

app.listen(PORT, async () => {
	await ensureUsersStore();
	console.log(`Auth server is running at http://localhost:${PORT}`);
});