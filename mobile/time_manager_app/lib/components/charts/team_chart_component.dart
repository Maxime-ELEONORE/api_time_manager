import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager_app/models/team.dart';

class TeamChartComponent extends StatefulWidget {
  const TeamChartComponent({Key? key, required this.team}) : super(key: key);
  final Team team;
  @override
  TeamChartComponentState createState() => TeamChartComponentState();
}

class TeamChartComponentState extends State<TeamChartComponent> {
  late Team team;
  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text("Team Chart")),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: Center(
            child: BarChart(
          BarChartData(barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  toY: double.parse("0"), color: Colors.blue, width: 20)
            ])
          ]),
          swapAnimationDuration: const Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        )));
  }
}
