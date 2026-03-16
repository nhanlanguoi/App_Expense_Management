import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../network/auth_api.dart';
import '../../model/users.dart';

class AuthService {
  static final AuthService instance = AuthService.internal();
  factory AuthService() => instance;
  AuthService.internal();

  final AuthApi _authApi = AuthApi();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final userBox = Hive.box('users');
  Users? currentUser;

  Future<Users?> login(String identifier, String password) async {
    final response = await _authApi.login(identifier: identifier, password: password);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<Users?> register({
    required String identifier,
    required String password,
    String? displayName,
  }) async {
    final response = await _authApi.register(
      identifier: identifier,
      password: password,
      displayName: displayName,
    );
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }


  Future<Users?> loginWithGoogle() async {
    // Clear stale local sessions to avoid reusing old cached tokens.
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null || googleAuth.accessToken == null) {
      throw Exception('Google token is missing. Check Firebase/Google Sign-In config (SHA-1, package name, google-services.json).');
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception('Google credential invalid. Verify SHA-1/SHA-256 and package name in Firebase project.');
      }
      rethrow;
    }
    final idToken = await userCredential.user?.getIdToken(true);

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Cannot get Google ID token');
    }

    final response = await _authApi.loginWithFirebase(idToken: idToken);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<Users?> loginWithFacebook() async {
    // Clear stale local sessions to avoid token/provider mismatch.
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}

    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
      return null;
    }

    final credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken(true);

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Cannot get Facebook ID token');
    }

    final response = await _authApi.loginWithFirebase(idToken: idToken);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<Users?> loginWithFirebaseEmailPassword({
    required String email,
    required String password,
  }) async {
    UserCredential credential;
    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      // Fallback for legacy local-backend accounts that are not in Firebase Auth.
      final response = await _authApi.login(identifier: email.trim(), password: password);
      final userMap = response['user'] as Map<String, dynamic>?;
      if (userMap == null) {
        return null;
      }
      currentUser = Users.fromApi(userMap);
      return currentUser;
    }

    await credential.user?.reload();
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Không thể đăng nhập Firebase');
    }
    if (!user.emailVerified) {
      throw Exception('Email chưa xác thực. Vui lòng kiểm tra hộp thư.');
    }

    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Không lấy được Firebase token');
    }

    final response = await _authApi.loginWithFirebase(idToken: idToken);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<void> registerEmailAndSendVerification({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
    }

    await credential.user?.sendEmailVerification();
  }

  Future<void> resendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Không tìm thấy phiên đăng ký email hiện tại');
    }
    await user.sendEmailVerification();
  }

  Future<Users?> loginVerifiedFirebaseEmailToBackend() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Không tìm thấy người dùng Firebase');
    }

    await user.reload();
    final refreshed = _firebaseAuth.currentUser;
    if (refreshed == null || !refreshed.emailVerified) {
      throw Exception('Email chưa được xác thực');
    }

    final idToken = await refreshed.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Không lấy được Firebase token');
    }

    final response = await _authApi.loginWithFirebase(idToken: idToken);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  // Legacy OTP helpers are kept for compatibility with older screens.
  Future<Map<String, dynamic>> requestEmailOtp({
    required String email,
    required String purpose,
  }) {
    return _authApi.requestEmailOtp(email: email, purpose: purpose);
  }

  Future<Users?> verifyRegisterOtp({
    required String email,
    required String code,
    required String password,
    String? displayName,
  }) async {
    final response = await _authApi.verifyRegisterOtp(
      email: email,
      code: code,
      password: password,
      displayName: displayName,
    );
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<void> verifyResetOtp({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _authApi.verifyResetOtp(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // If backend session is already expired or unreachable, we still clear local auth state.
    }

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}

    try {
      await _firebaseAuth.signOut();
    } catch (_) {}

    currentUser = null;
  }


  Future<void> updateUserBalance(String email, double newBalance) async {

    if (currentUser != null && currentUser!.email == email) {
      currentUser = Users(
        id: currentUser!.id,
        username: currentUser!.username,
        email: currentUser!.email,
        password: currentUser!.password,
        avatarUrl: currentUser!.avatarUrl,
        totalBalance: newBalance,
      );
    }


    var userData = userBox.get(email);


    Map<String, dynamic> userMap = userData != null
        ? Map<String, dynamic>.from(userData)
        : (currentUser?.toMap() ?? {});

    userMap['total_balance'] = newBalance;
    await userBox.put(email, userMap);
  }

}