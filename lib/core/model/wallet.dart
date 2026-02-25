class Wallet {
  final String? id;
  final String userEmail;
  final String name;
  final String icon;
  final String color;
  final double balance;

  Wallet({
    this.id,
    required this.userEmail,
    required this.name,
    required this.icon,
    required this.color,
    this.balance = 0.0,
  });


  Map<String, dynamic> toMap() {
    return {
      'user_email': userEmail,
      'name': name,
      'icon': icon,
      'color': color,
      'balance': balance,
    };
  }


  factory Wallet.fromMap(String id, Map<dynamic, dynamic> map) {
    return Wallet(
      id: id,
      userEmail: map['user_email'] ?? '',
      name: map['name'] ?? 'Ví không tên',
      icon: map['icon'] ?? 'default_icon',
      color: map['color'] ?? '#000000',

      balance: (map['balance'] ?? 0).toDouble(),
    );
  }


  static List<Wallet> testWallets() {
    return [
      Wallet(
        id: 'wallet_001',
        userEmail: 'admin',
        name: 'Tiền mặt',
        icon: 'wallet',
        color: '#FF5733',
        balance: 5000000,
      ),
      Wallet(
        id: 'wallet_002',
        userEmail: 'admin',
        name: 'Vietcombank',
        icon: 'bank',
        color: '#2196F3',
        balance: 12000000,
      ),
    ];
  }
}