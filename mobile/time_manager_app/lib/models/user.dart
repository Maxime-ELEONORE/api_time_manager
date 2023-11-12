class User {
  String id;
  String username;
  String email;
  String role;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.role});

  User.constructor(this.id, this.username, this.email, this.role);

  User.empty()
      : id = "",
        username = "",
        email = "",
        role = "User";

  User.copy(User user)
      : id = user.id,
        username = user.username,
        email = user.email,
        role = user.role;

  static User fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        role: json['role']);
  }

  static User fromJsonForToken(Map<String, dynamic> json) {
    return User(
        id: json['user_id'],
        username: json['username'],
        email: json['email'],
        role: json['role']);
  }
}
