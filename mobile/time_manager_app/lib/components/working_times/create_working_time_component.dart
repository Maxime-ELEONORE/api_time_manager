import 'package:flutter/material.dart';
import 'package:time_manager_app/components/shared/date_time_picker_custom.dart';
import 'package:time_manager_app/functions/function.dart';
import 'package:time_manager_app/models/working_time.dart';

class CreateWorkingTimeComponent extends StatefulWidget {
  final WorkingTime workingTime;

  const CreateWorkingTimeComponent({super.key, required this.workingTime});

  @override
  State<StatefulWidget> createState() => CreateWorkingTimeComponentState();
}

class CreateWorkingTimeComponentState
    extends State<CreateWorkingTimeComponent> {
  late WorkingTime workingTime;
  @override
  void initState() {
    super.initState();
    workingTime = widget.workingTime; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: displayTitle()),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: DateTimePickerCustom(
                        titleButton: "Select start Date & Time",
                        onDateTimeSelected: (dateTime) {
                          setState(() {
                            workingTime.start = dateTime.toString();
                          });
                        })),
                DateTimePickerCustom(
                    titleButton: "Select end Date & Time",
                    onDateTimeSelected: (dateTime) {
                      setState(() {
                        workingTime.end = dateTime.toString();
                      });
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(workingTime.start == ""
                        ? "Select start Date & Time"
                        : CommonFunctions.formatDateFromString(
                            workingTime.start))),
                Text(workingTime.end == ""
                    ? "Select end Date & Time"
                    : CommonFunctions.formatDateFromString(workingTime.end))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecte UserName',
              ),

            )
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  if (DateTime.parse(workingTime.start)
                      .isAfter(DateTime.parse(workingTime.end))) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Start date must be before end date!",
                            style: TextStyle(color: Colors.red))));
                  } else {
                    if (workingTime.id == "") {
                      //call create http request
                    } else {
                      // call update http request
                    }
                    Navigator.pop(context, workingTime);
                  }
                },
                child: displayTitle(),
              ))
        ]));
  }

  Widget displayTitle() {
    if (workingTime.id == "") {
      return const Text("Create WorkingTime");
    }
    return const Text("Update WorkingTime");
  }
}
