import 'package:hive_flutter/hive_flutter.dart';
import '../../model/transactions.dart';

class TransactionService {
  List<TransactionRecord> getTransactionsByWallet(String walletId) {
    var box = Hive.box('transactions');
    List<TransactionRecord> results = [];

    for (var key in box.keys) {
      var value = box.get(key);
      var transaction = TransactionRecord.fromMap(key.toString(), Map<dynamic, dynamic>.from(value));

      if (transaction.walletId == walletId) {
        results.add(transaction);
      }
    }

    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  int gettotalTransaction(String walletId){
    var box = Hive.box('transactions');
    List<TransactionRecord> results = [];

    for (var key in box.keys) {
      var value = box.get(key);
      var transaction = TransactionRecord.fromMap(key.toString(), Map<dynamic, dynamic>.from(value));

      if (transaction.walletId == walletId) {
        results.add(transaction);
      }
    }
    int total = results.length;
    return total;
  }
}