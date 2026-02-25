import 'package:hive_flutter/hive_flutter.dart';
import '../../model/wallet.dart';

class WalletService {
  final box = Hive.box('wallets');
  List<Wallet> getWallets(String userEmail) {

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

  Future<void> addWallet(Wallet wallet) async {
    await box.put(wallet.id, wallet.toMap());
  }

  Future<void> deleteWallet(String id) async {
    await box.delete(id);
  }
}