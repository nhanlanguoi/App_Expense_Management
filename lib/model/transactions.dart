class TransactionRecord {
  final String? id;
  final String walletId;
  final String title;
  final double amount;
  final String type;
  final DateTime date;
  final String icon;
  final String color;

  TransactionRecord({
    this.id,
    required this.walletId,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'wallet_id': walletId,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'icon': icon,
      'color': color,
    };
  }

  factory TransactionRecord.fromMap(String id, Map<dynamic, dynamic> map) {
    return TransactionRecord(
      id: id,
      walletId: map['wallet_id'] ?? '',
      title: map['title'] ?? 'Giao dịch',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'expense',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      icon: map['icon'] ?? 'fastfood',
      color: map['color'] ?? '#FF0000',
    );
  }


  static List<TransactionRecord> testTransactions() {
    return [
      TransactionRecord(
        id: 'trans_001',
        walletId: 'wallet_001',
        title: 'Ăn sáng Phở Bát Đàn',
        amount: 50000,
        type: 'expense',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        icon: 'fastfood',
        color: '#FF9800',
      ),
      TransactionRecord(
        id: 'trans_002',
        walletId: 'wallet_001', 
        title: 'Mua cafe',
        amount: 35000,
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 1)),
        icon: 'local_cafe',
        color: '#795548',
      ),
      TransactionRecord(
        id: 'trans_003',
        walletId: 'wallet_002',
        title: 'Nhận lương tháng 2',
        amount: 15000000,
        type: 'income',
        date: DateTime.now().subtract(const Duration(days: 2)),
        icon: 'payments',
        color: '#4CAF50',
      ),
    ];
  }
}