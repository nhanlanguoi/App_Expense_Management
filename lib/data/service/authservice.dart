import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_management/model/users.dart';

class AuthService {
  static final AuthService instance = AuthService.internal();
  factory AuthService() => instance;
  AuthService.internal();

  final userBox = Hive.box('users');

  Users? currentUser;

  Future<Users?> login(String email, String password) async {
    var userData = userBox.get(email);

    if (userData != null) {
      final userMap = Map<String, dynamic>.from(userData);
      if (userMap['password'] == password) {
        currentUser = Users.fromMap(userMap);
        return currentUser;
      }
    }
    return null;
  }

  Future<void> register(Users user) async {
    await userBox.put(user.email, user.toMap());
    print("Đã đăng ký user mới: ${user.email}");
  }
}