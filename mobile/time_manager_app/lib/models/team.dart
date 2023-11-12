import 'package:time_manager_app/models/user.dart';

class Team {
  String id;
  String name;
  List<User> users;

  Team({required this.id, required this.name, required this.users});

  Team.constructor(this.id, this.name, this.users);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        id: json['id'],
        name: json['name'],
        users: (json['users'] as List).map((e) => User.fromJson(e)).toList());
  }

  Team.empty()
      : id = "",
        name = "",
        users = [];
}
