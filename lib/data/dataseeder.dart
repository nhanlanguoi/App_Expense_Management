import 'package:hive_flutter/hive_flutter.dart';
import '../model/users.dart';

class DataSeeder {
  static Future<void> seed() async {
    var userBox = Hive.box('users');


    if (!userBox.containsKey('admin')) {
      print("tạo User Admin ");
      final adminUser = Users.testUser();

      await userBox.put('admin', adminUser.toMap());
      print("tạo xong User 'admin'.");
    } else {
      print("User 'admin' đã có sẵn.");
    }
  }
}