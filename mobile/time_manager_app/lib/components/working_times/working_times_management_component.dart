import 'package:flutter/material.dart';
import 'package:time_manager_app/components/working_times/create_working_time_component.dart';
import 'package:time_manager_app/models/working_time.dart';

class WorkingTimesManagementComponent extends StatefulWidget {
  const WorkingTimesManagementComponent({super.key});
  @override
  State<StatefulWidget> createState() => WorkingTimesManagementComponentState();
}

class WorkingTimesManagementComponentState
    extends State<WorkingTimesManagementComponent> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Working Times Management")),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CreateWorkingTimeComponent(
                        workingTime: WorkingTime.empty(),
                      );
                    }));
                  },
                  icon: const Icon(Icons.add, size: 30),
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
          ),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        columns: const [
                          DataColumn(label: Text("Start")),
                          DataColumn(label: Text("End")),
                          DataColumn(label: Text("User Id")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: [
                          for (var workingTime in workingTimes)
                            DataRow(cells: [
                              DataCell(Text(workingTime.start)),
                              DataCell(Text(workingTime.end)),
                              DataCell(Text(workingTime.userId)),
                              DataCell(Row(children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    //remove user
                                    setState(() {});
                                  },
                                )
                              ])),
                            ]),
                        ],
                      ))))
        ]));
  }
}
