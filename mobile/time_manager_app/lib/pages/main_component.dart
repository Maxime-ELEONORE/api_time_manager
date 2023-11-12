import 'package:flutter/material.dart';
import 'package:time_manager_app/components/clocks/clock_component.dart';
import 'package:time_manager_app/components/charts/charts_component.dart';
import 'package:time_manager_app/components/users/profile_component.dart';
import 'package:time_manager_app/components/teams/teams_management_component.dart';
import 'package:time_manager_app/components/users/users_management_component.dart';
import 'package:time_manager_app/components/working_times/working_times_component.dart';
import 'package:time_manager_app/components/working_times/working_times_management_component.dart';
import 'package:time_manager_app/main.dart';
import 'package:time_manager_app/models/Clock.dart';
import 'package:time_manager_app/models/user.dart';
import 'package:time_manager_app/service/local_storage_service.dart';
import 'package:time_manager_app/service/session_service.dart';

class MainComponentView extends StatefulWidget {
  const MainComponentView({super.key});

  @override
  State<StatefulWidget> createState() => MainComponentViewState();
}

class MainComponentViewState extends State<MainComponentView> {
  late String time = DateTime.now().toLocal().toString();
  late Clock clock;
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    ClockComponent(),
    WorkingTimesComponent(),
    ChartsComponent(),
    ProfileComponent()
  ];
  SessionService sessionService = SessionService();
  late User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = LocalStorageService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text("Time Manager App")),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading:
              currentUser == null || currentUser?.role == "User" ? false : true,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      setState(() {
                        sessionService.logOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyHomePage(title: "Time Manager App");
                        }));
                      });
                    }))
          ]),
      drawer: currentUser == null || currentUser?.role == "User"
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Center(
                              child: Row(children: [
                            Icon(Icons.admin_panel_settings),
                            Text('Privileges')
                          ]))
                        ]),
                  ),
                  ListTile(
                    title: const Row(children: [
                      Icon(Icons.assignment_ind),
                      Text('User Management'),
                    ]),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const UsersManagementComponent();
                      }));
                    },
                  ),
                  ListTile(
                    title: const Row(children: [
                      Icon(Icons.calendar_month),
                      Text('Working Times Management'),
                    ]),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const WorkingTimesManagementComponent();
                      }));
                    },
                  ),
                  ListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.people),
                        Text('Teams Management'),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const TeamsManagementComponent();
                      }));
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeView,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'WorkingTimes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          )
        ],
      ),
      body: _tabs[_selectedIndex],
    );
  }

  changeView(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
