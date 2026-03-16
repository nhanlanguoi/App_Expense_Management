const express = require("express");
const requireAuth = require("../middlewares/require-auth");
const authController = require("../controllers/auth-controller");

const router = express.Router();

router.post("/register", authController.register);
router.post("/login", authController.login);
router.post("/firebase", authController.firebaseLogin);
router.post("/logout", requireAuth, authController.logout);
router.get("/me", requireAuth, authController.me);

module.exports = router;
