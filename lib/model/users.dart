class Users {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? avatarUrl;
  final double totalBalance;

  Users({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.totalBalance = 0,
  });

  factory Users.testUser() {
    return Users(
      username: "Tester Pro",
      email: "admin",
      password: "123",
      totalBalance: 12000000,
      avatarUrl: "assets/images/avatar_default.png",
    );
  }

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    username: json['username'],
    email: json['email'],
    password: json['password'],
    totalBalance: (json['total_balance'] ?? 0).toDouble(),
    avatarUrl: json['avatar_url'],
  );

  Map<String, dynamic> toMap() => {
    'username': username,
    'email': email,
    'password': password,
    'total_balance': totalBalance,
    'avatar_url': avatarUrl,
  };
}
