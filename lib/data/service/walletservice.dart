import 'package:hive_flutter/hive_flutter.dart';
import '../../model/wallet.dart';

class WalletService {
  List<Wallet> getWallets(String userEmail) {
    var box = Hive.box('wallets');

    List<Wallet> results = [];

    for (var key in box.keys) {
      var value = box.get(key);

      var wallet = Wallet.fromMap(key.toString(), Map<dynamic, dynamic>.from(value));

      if (wallet.userEmail == userEmail) {
        results.add(wallet);
      }
    }
    return results;
  }
}