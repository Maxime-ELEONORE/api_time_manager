import 'package:flutter/material.dart';
import 'package:time_manager_app/components/users/create_user_component.dart';
import 'package:time_manager_app/models/user.dart';

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({super.key});
  @override
  ProfileComponentState createState() => ProfileComponentState();
}

class ProfileComponentState extends State<ProfileComponent> {
  List<String> dropdownValues = <String>['User', 'Super User', 'User Manager'];
  late User user = User.constructor("id", "John", "John.doe@Gmail.com", "User");
  final User initialUser =
      User.constructor("id", "John", "John.doe@Gmail.com", "User");
  @override
  Widget build(BuildContext context) {
    return CreateUserComponent(user: user, isProfile: true);
  }
}
