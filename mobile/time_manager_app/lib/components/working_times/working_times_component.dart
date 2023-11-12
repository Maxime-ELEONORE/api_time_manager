import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manager_app/functions/function.dart';
import 'package:time_manager_app/models/working_time.dart';

class WorkingTimesComponent extends StatefulWidget {
  const WorkingTimesComponent({super.key});

  @override
  State<StatefulWidget> createState() => WorkingTimesComponentState();
}

class WorkingTimesComponentState extends State<WorkingTimesComponent> {
  List<WorkingTime> workingTimes = [];

  @override
  void initState() {
    super.initState();
    workingTimes = [
      WorkingTime(
          id: "id",
          userId: "userId",
          start: "2022-06-01 08:00:00",
          end: "2022-06-01 16:00:00")
    ];
    workingTimes = List.generate(
        50,
        (index) => WorkingTime(
            id: "id",
            userId: "userId",
            start: "2022-06-01 08:00:00",
            end: "2022-06-01 16:00:00"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Working Times")),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                width: double.maxFinite,
                child: DataTable(
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  columns: const [
                    DataColumn(label: Text("Start")),
                    DataColumn(label: Text("End")),
                    DataColumn(label: Text("Duration")),
                  ],
                  rows: [
                    for (var workingTime in workingTimes)
                      DataRow(cells: [
                        DataCell(Text(workingTime.start)),
                        DataCell(Text(workingTime.end)),
                        DataCell(Text(CommonFunctions.formatTimeFromDuration(
                            DateFormat("yyyy-MM-dd hh:mm:ss")
                                .parse(workingTime.end)
                                .difference(DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(workingTime.start))))),
                      ])
                  ],
                ))));
  }
}
