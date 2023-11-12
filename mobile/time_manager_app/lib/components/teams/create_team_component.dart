import 'package:flutter/material.dart';
import 'package:time_manager_app/models/team.dart';
import 'package:time_manager_app/models/user.dart';

class CreateTeamComponent extends StatefulWidget {
  final Team team;

  const CreateTeamComponent({super.key, required this.team});
  @override
  State<StatefulWidget> createState() => CreateTeamComponentState();
}

class CreateTeamComponentState extends State<CreateTeamComponent> {
  late Team team;
  String searchValue = "";

  late List<User> users;

  @override
  void initState() {
    super.initState();
    team = widget.team;
    users = [
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jihn", "John.doe@Gzail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jihn", "John.doe@Gzail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jihn", "John.doe@Gzail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jihn", "John.doe@Gzail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: displayTitle()),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              controller: TextEditingController(text: team.name),
              decoration: const InputDecoration(
                hintText: "Team Name",
              ),
              onChanged: (value) => team.name = value,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (User user in team.users)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                        width: 150,
                                        child: Text(user.username))),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        team.users.remove(user);
                                      });
                                    })
                              ]),
                      ],
                    ),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Search"),
              onChanged: (value) => {
                setState(() {
                  searchValue = value;
                })
              },
            ),
            SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: displayUsers(),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    //call create http request
                    if (team.id == "") {
                      //call create http request
                    } else {
                      // call update http request
                    }
                    Navigator.pop(context);
                  },
                  child: displayTitle(),
                ))
          ]),
        ));
  }

  Widget displayTitle() {
    if (team.id == "") {
      return const Text("Create Team");
    }
    return Text("Update Team ${team.name}");
  }

  List<Widget> displayUsers() {
    List<User> displayableUsers = [];

    if (searchValue != "") {
      displayableUsers = users.where((user) {
        return user.username
                .toUpperCase()
                .contains(searchValue.toUpperCase()) &&
            !team.users.contains(user);
      }).toList();
    } else {
      displayableUsers =
          users.where((user) => !team.users.contains(user)).toList();
    }

    return displayableUsers
        .map((user) =>
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(width: 200, child: Text(user.username))),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  setState(() {
                    team.users.add(user);
                  });
                },
              )
            ]))
        .toList();
  }
}
