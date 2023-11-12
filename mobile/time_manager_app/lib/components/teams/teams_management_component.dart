import 'package:flutter/material.dart';
import 'package:time_manager_app/components/charts/team_chart_component.dart';
import 'package:time_manager_app/components/teams/create_team_component.dart';
import 'package:time_manager_app/models/team.dart';
import 'package:time_manager_app/models/user.dart';

class TeamsManagementComponent extends StatefulWidget {
  const TeamsManagementComponent({super.key});
  @override
  TeamsManagementComponentState createState() =>
      TeamsManagementComponentState();
}

class TeamsManagementComponentState extends State<TeamsManagementComponent> {
  List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    teams = [
      Team(id: "id", name: "Le ssucerus", users: [
        User(
          id: "id",
          username: "John",
          email: "John.doe@Gmail.com",
          role: "User",
        )
      ]),
      Team(id: "id", name: "name", users: [
        User(
          id: "id",
          username: "John",
          email: "John.doe@Gmail.com",
          role: "User",
        )
      ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Teams")),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateTeamComponent(team: Team.empty());
                      }));
                    },
                    icon: const Icon(Icons.add, size: 30),
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            ),
            SingleChildScrollView(
                child: Column(
              children: [
                for (Team team in teams)
                  Column(children: [
                    ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(child: Text(team.name)),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return TeamChartComponent(team: team);
                                        },
                                      ));
                                    },
                                    icon: const Icon(Icons.bar_chart)),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return CreateTeamComponent(
                                                team: team);
                                          }));
                                        },
                                        icon: const Icon(Icons.edit))))
                          ],
                        ),
                        children: [
                          for (User user in team.users) Text(user.username),
                        ]),
                  ]),
              ],
            )),
          ],
        ));
  }
}
