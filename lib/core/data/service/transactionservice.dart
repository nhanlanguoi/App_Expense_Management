import 'package:hive_flutter/hive_flutter.dart';
import '../../model/transactions.dart';
import 'walletservice.dart';

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

  double getpriceTransaction(String walletId){
    var box = Hive.box('transactions');

    double totalprice =0;

    for (var key in box.keys) {
      var value = box.get(key);
      var transaction = TransactionRecord.fromMap(key.toString(), Map<dynamic, dynamic>.from(value));

      if (transaction.walletId == walletId) {
        totalprice += transaction.amount.toDouble();
      }
    }

    return totalprice;
  }
  Future<void> deleteTransactions(List<String> transactionIds) async {
    var box = Hive.box('transactions');
    await box.deleteAll(transactionIds);
  }
  Future<void> addTransaction(TransactionRecord transaction) async {
    var box = Hive.box('transactions');
    await box.put(transaction.id, transaction.toMap());
  }

  List<TransactionRecord> getAllUserTransactions(String email) {
    final myWallets = WalletService().getWallets(email);
    List<TransactionRecord> allTransactions = [];

    for (var wallet in myWallets) {
      if (wallet.id != null) {
        allTransactions.addAll(getTransactionsByWallet(wallet.id!));
      }
    }
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }


  double getTotalNetBalance(List<TransactionRecord> transactions) {
    double totalAmount = 0;
    for (var t in transactions) {
      if (t.type == 'income') {
        totalAmount += t.amount;
      } else {
        totalAmount -= t.amount;
      }
    }
    return totalAmount;
  }
}