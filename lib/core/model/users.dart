class Users {
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? avatarUrl;
  final double totalBalance;
  final double monthlySalary;
  final String? salaryLastCreditedMonth;
  final double savingsBalance;
  final String? balanceMonthKey;

  static double _safeDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  Users({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.totalBalance = 0,
    this.monthlySalary = 0,
    this.salaryLastCreditedMonth,
    this.savingsBalance = 0,
    this.balanceMonthKey,
  });

  factory Users.testUser() {
    return Users(
      username: "Tester Pro",
      email: "admin",
      password: "123",
      totalBalance: 12000000,
      monthlySalary: 0,
      savingsBalance: 0,
      avatarUrl: "assets/images/avatar_default.png",
    );
  }

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json['id']?.toString(),
    username: json['username'],
    email: json['email'],
    password: json['password'],
    totalBalance: _safeDouble(json['total_balance']),
    monthlySalary: _safeDouble(json['monthly_salary']),
    salaryLastCreditedMonth: json['salary_last_credited_month']?.toString(),
    savingsBalance: _safeDouble(json['savings_balance']),
    balanceMonthKey: json['balance_month_key']?.toString(),
    avatarUrl: json['avatar_url'],
  );

  factory Users.fromApi(Map<String, dynamic> json) => Users(
    id: json['id']?.toString(),
    username: (json['displayName'] ?? json['username'] ?? '').toString(),
    email: (json['email'] ?? '').toString(),
    password: '',
    totalBalance: _safeDouble(json['total_balance']),
    monthlySalary: _safeDouble(json['monthly_salary']),
    salaryLastCreditedMonth: json['salary_last_credited_month']?.toString(),
    savingsBalance: _safeDouble(json['savings_balance']),
    balanceMonthKey: json['balance_month_key']?.toString(),
    avatarUrl: json['avatar_url'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'total_balance': totalBalance,
    'monthly_salary': monthlySalary,
    'salary_last_credited_month': salaryLastCreditedMonth,
    'savings_balance': savingsBalance,
    'balance_month_key': balanceMonthKey,
    'avatar_url': avatarUrl,
  };
}
