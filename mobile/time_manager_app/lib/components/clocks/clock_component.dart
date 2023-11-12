import 'package:flutter/material.dart';
import 'package:time_manager_app/functions/function.dart';
import 'package:time_manager_app/models/clock.dart';
import 'package:time_manager_app/models/user.dart';
import 'package:time_manager_app/repository/clock_repository.dart';
import 'package:time_manager_app/service/local_storage_service.dart';

class ClockComponent extends StatefulWidget {
  const ClockComponent({super.key});

  @override
  State<StatefulWidget> createState() => ClockViewState();
}

class ClockViewState extends State<ClockComponent> {
  late Clock clock;
  late User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = LocalStorageService.getUser();
  }

  Future<Clock> getLastClock() async {
    try {
      final List<Clock> response = await ClockRepository().getClocks();
      response.sort((a, b) => a.time.compareTo(b.time));
      return response.last;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Widget displayButton() {
    if (clock.status == true) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            ClockRepository().createClock(clock);
            clock.status = false;
          });
        },
        child: const Text("Clock in"),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            clock.status = true;
          });
        },
        child: const Text("Clock out"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Clock>(
        future: getLastClock(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            clock = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text("Clock")),
                  automaticallyImplyLeading: false,
                ),
                body: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50, top: 100),
                          child: Text(
                            "Welcome ${currentUser?.username ?? ""}",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  CommonFunctions.formatTimeFromString(
                                      clock.time),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: displayButton())
                              ]),
                        )
                      ]),
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
