import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../network/auth_api.dart';
import '../../model/users.dart';

class AuthService {
  static final AuthService instance = AuthService.internal();
  factory AuthService() => instance;
  AuthService.internal();

  final AuthApi _authApi = AuthApi();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Cannot get Google ID token');
    }

    final response = await _authApi.loginWithGoogle(idToken: idToken);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<Users?> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
      return null;
    }

    final credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Cannot get Facebook ID token');
    }

    final response = await _authApi.loginWithFacebook(idToken: idToken);
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
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

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

}