import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox('users');
    await Hive.openBox('wallets');
    await Hive.openBox('transactions');
    await Hive.openBox('category_groups');
    await Hive.openBox('categories');
    await Hive.openBox('budget_allocations');

    print("tạo xong Box.");
  }
}