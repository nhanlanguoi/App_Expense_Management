import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox('users');

    print("tạo xong Box.");
  }
}