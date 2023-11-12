import 'package:flutter/material.dart';
import 'package:time_manager_app/models/user.dart';

class PieChartComponent extends StatefulWidget {
  const PieChartComponent({Key? key, required this.users}) : super(key: key);
  final List<User> users;
  @override
  PieChartComponentState createState() => PieChartComponentState();
}

class PieChartComponentState extends State<PieChartComponent> {
  late List<User> users;

  @override
  void initState() {
    super.initState();
    users = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
