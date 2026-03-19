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

  String _monthKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }

  DateTime? _monthFromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) return null;
    return DateTime(year, month);
  }

  String _nextMonthKey(String key) {
    final month = _monthFromKey(key);
    if (month == null) return key;
    final next = DateTime(month.year, month.month + 1);
    return _monthKey(next);
  }

  Future<Box> _ensureBudgetBox() async {
    if (!Hive.isBoxOpen('budget_allocations')) {
      await Hive.openBox('budget_allocations');
    }
    return Hive.box('budget_allocations');
  }

  double _getAllocatedForMonth(Map<String, dynamic> budgetMap, String monthKey) {
    final months = budgetMap['months'];
    if (months is Map) {
      final monthDataRaw = months[monthKey];
      if (monthDataRaw is Map) {
        final monthData = Map<String, dynamic>.from(monthDataRaw);
        final amountsRaw = monthData['amounts'];
        if (amountsRaw is Map) {
          final amounts = Map<String, dynamic>.from(amountsRaw);
          return amounts.values.fold<double>(0, (sum, value) => sum + _safeDouble(value));
        }
      }
    }
    return 0;
  }

  void _ensureCurrentMonthBudgetNode(Map<String, dynamic> budgetMap, String monthKey) {
    final rawMonths = budgetMap['months'];
    final months = rawMonths is Map ? Map<String, dynamic>.from(rawMonths) : <String, dynamic>{};
    final monthRaw = months[monthKey];
    final monthData = monthRaw is Map ? Map<String, dynamic>.from(monthRaw) : <String, dynamic>{};
    final amountsRaw = monthData['amounts'];
    monthData['amounts'] = amountsRaw is Map ? Map<String, dynamic>.from(amountsRaw) : <String, dynamic>{};
    months[monthKey] = monthData;
    budgetMap['months'] = months;
  }

  double _safeDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  void _syncCurrentUserFromMap(Map<String, dynamic> userMap) {
    final email = userMap['email']?.toString();
    if (currentUser != null && currentUser!.email == email) {
      currentUser = Users.fromMap(userMap);
    }
  }

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

    final userData = userBox.get(email);
    final userMap = userData != null
        ? Map<String, dynamic>.from(userData)
        : (currentUser?.toMap() ?? <String, dynamic>{'email': email});

    userMap['total_balance'] = newBalance;
    await userBox.put(email, userMap);
    _syncCurrentUserFromMap(userMap);
  }

  Future<void> updateUserMonthlySalary(String email, double salary) async {
    final userData = userBox.get(email);
    final userMap = userData != null
        ? Map<String, dynamic>.from(userData)
        : (currentUser?.toMap() ?? <String, dynamic>{'email': email});

    userMap['monthly_salary'] = salary;
    await userBox.put(email, userMap);
    await reconcileMonthlyBalance(email, rebuildCurrentMonthBalance: true);
  }

  Future<void> applyIncomeTransaction({
    required String email,
    required double amount,
    required DateTime transactionDate,
    String? categoryId,
  }) async {
    if (amount <= 0) return;

    final now = DateTime.now();
    final isCurrentMonth =
        transactionDate.month == now.month && transactionDate.year == now.year;

    // Keep monthly-balance behavior stable: only current month transactions affect
    // current working balance/allocation bucket.
    if (!isCurrentMonth) return;

    final userData = userBox.get(email);
    final userMap = userData != null
        ? Map<String, dynamic>.from(userData)
        : (currentUser?.toMap() ?? <String, dynamic>{'email': email});

    final currentBalance = _safeDouble(userMap['total_balance']);
    userMap['total_balance'] = currentBalance + amount;
    await userBox.put(email, userMap);
    _syncCurrentUserFromMap(userMap);

    final normalizedCategoryId = categoryId?.trim();
    if (normalizedCategoryId == null || normalizedCategoryId.isEmpty) {
      return;
    }

    final budgetBox = await _ensureBudgetBox();
    final rawBudget = budgetBox.get(email);
    final budgetMap = rawBudget is Map
        ? Map<String, dynamic>.from(rawBudget)
        : <String, dynamic>{'user_email': email};

    // Migration: old format {'amounts': {...}} -> {'months': {'YYYY-MM': {'amounts': {...}}}}
    if (budgetMap['months'] is! Map && budgetMap['amounts'] is Map) {
      final nowKey = _monthKey(now);
      budgetMap['months'] = {
        nowKey: {
          'amounts': Map<String, dynamic>.from(budgetMap['amounts'] as Map),
        }
      };
      budgetMap.remove('amounts');
    }

    final monthKey = _monthKey(now);
    _ensureCurrentMonthBudgetNode(budgetMap, monthKey);

    final months = Map<String, dynamic>.from(budgetMap['months'] as Map);
    final monthRaw = months[monthKey];
    final monthData = monthRaw is Map
        ? Map<String, dynamic>.from(monthRaw)
        : <String, dynamic>{};
    final amountsRaw = monthData['amounts'];
    final amounts = amountsRaw is Map
        ? Map<String, dynamic>.from(amountsRaw)
        : <String, dynamic>{};

    amounts[normalizedCategoryId] =
        _safeDouble(amounts[normalizedCategoryId]) + amount;
    monthData['amounts'] = amounts;
    months[monthKey] = monthData;
    budgetMap['months'] = months;
    budgetMap['updated_at'] = DateTime.now().toIso8601String();

    await budgetBox.put(email, budgetMap);
  }

  Future<bool> applyMonthlySalaryIfNeeded(String email) async {
    return reconcileMonthlyBalance(email);
  }

  Future<bool> reconcileMonthlyBalance(
    String email, {
    bool rebuildCurrentMonthBalance = false,
  }) async {
    final userData = userBox.get(email);
    final userMap = userData != null
        ? Map<String, dynamic>.from(userData)
        : (currentUser?.toMap() ?? <String, dynamic>{'email': email});

    final budgetBox = await _ensureBudgetBox();
    final rawBudget = budgetBox.get(email);
    final budgetMap = rawBudget is Map ? Map<String, dynamic>.from(rawBudget) : <String, dynamic>{'user_email': email};

    // Migration: old format {'amounts': {...}} -> {'months': {'YYYY-MM': {'amounts': {...}}}}
    if (budgetMap['months'] is! Map && budgetMap['amounts'] is Map) {
      final nowKey = _monthKey(DateTime.now());
      budgetMap['months'] = {
        nowKey: {
          'amounts': Map<String, dynamic>.from(budgetMap['amounts'] as Map),
        }
      };
      budgetMap.remove('amounts');
    }

    final monthlySalary = _safeDouble(userMap['monthly_salary']);
    final nowKey = _monthKey(DateTime.now());
    String? balanceMonthKey = userMap['balance_month_key']?.toString();
    double savingsBalance = _safeDouble(userMap['savings_balance']);
    double currentMonthBalance = _safeDouble(userMap['total_balance']);

    bool changed = false;

    if (balanceMonthKey == null || balanceMonthKey.isEmpty) {
      balanceMonthKey = nowKey;
      if (rebuildCurrentMonthBalance || currentMonthBalance <= 0) {
        currentMonthBalance = savingsBalance + monthlySalary;
      }
      userMap['balance_month_key'] = balanceMonthKey;
      userMap['total_balance'] = currentMonthBalance;
      changed = true;
    }

    // Roll through month boundaries and carry remaining balance into savings.
    while (balanceMonthKey != nowKey) {
      final allocated = _getAllocatedForMonth(budgetMap, balanceMonthKey!);
      final leftover = (currentMonthBalance - allocated) < 0 ? 0.0 : (currentMonthBalance - allocated);
      savingsBalance = leftover;

      final nextKey = _nextMonthKey(balanceMonthKey);
      if (nextKey == balanceMonthKey) {
        break;
      }

      balanceMonthKey = nextKey;
      currentMonthBalance = savingsBalance + monthlySalary;

      userMap['savings_balance'] = savingsBalance;
      userMap['balance_month_key'] = balanceMonthKey;
      userMap['total_balance'] = currentMonthBalance;
      changed = true;
    }

    if (rebuildCurrentMonthBalance) {
      currentMonthBalance = savingsBalance + monthlySalary;
      userMap['total_balance'] = currentMonthBalance;
      userMap['balance_month_key'] = nowKey;
      changed = true;
    }

    userMap['salary_last_credited_month'] = nowKey;
    userMap['savings_balance'] = savingsBalance;
    _ensureCurrentMonthBudgetNode(budgetMap, nowKey);
    budgetMap['updated_at'] = DateTime.now().toIso8601String();

    await budgetBox.put(email, budgetMap);
    await userBox.put(email, userMap);
    _syncCurrentUserFromMap(userMap);
    return changed;
  }

}