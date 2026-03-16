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

  Future<Users?> login(String username, String password) async {
    final response = await _authApi.login(username: username, password: password);
    final userMap = response['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      return null;
    }
    currentUser = Users.fromApi(userMap);
    return currentUser;
  }

  Future<Users?> register({required String username, required String password}) async {
    final response = await _authApi.register(username: username, password: password);
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
}