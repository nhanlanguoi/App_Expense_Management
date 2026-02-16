class Users {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? avatarUrl;

  Users({this.id,required this.username,required this.email,required this.password, this.avatarUrl});



  factory Users.testUser() {
    return Users(
      id: 999,
      username: "Tester Pro",
      email: "admin",
      password: "123",
      avatarUrl: "assets/images/avatar_default.png",
    );
  }


  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    password: json['password'],
    avatarUrl: json['avatar_url'],
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'avatar_url': avatarUrl,
  };

}