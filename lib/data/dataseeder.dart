import 'package:hive_flutter/hive_flutter.dart';
import '../model/users.dart';
import 'package:expense_management/model/wallet.dart';

class DataSeeder {
  static Future<void> seedusers() async {
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

  static Future<void> seedwallet() async{
    var walletBox = Hive.box('wallets');

    List<Wallet> wallet = Wallet.testWallets();

    for(var x in wallet){
      if(!walletBox.containsKey(x.id)){
        await walletBox.put(x.id, x.toMap());
      }
    }
  }
}