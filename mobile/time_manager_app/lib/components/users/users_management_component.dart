import 'package:flutter/material.dart';
import 'package:time_manager_app/components/users/create_user_component.dart';
import 'package:time_manager_app/models/user.dart';

class UsersManagementComponent extends StatefulWidget {
  const UsersManagementComponent({super.key});

  @override
  State<StatefulWidget> createState() => UsersManagementComponentState();
}

class UsersManagementComponentState extends State<UsersManagementComponent> {
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    users = [
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "John", "John.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User"),
      User.constructor("id", "Jane", "Jane.doe@Gmail.com", "User")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Users Management")),
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
                      return CreateUserComponent(user: User.empty());
                    }));
                  },
                  icon: const Icon(Icons.add, size: 30),
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
          ),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        columns: const [
                          DataColumn(label: Text("Username")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Role")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: [
                          for (var user in users)
                            DataRow(cells: [
                              DataCell(Text(user.username)),
                              DataCell(Text(user.email)),
                              DataCell(Text(user.role)),
                              DataCell(Row(children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CreateUserComponent(user: user);
                                    }));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    //remove user
                                    setState(() {
                                      users.remove(user);
                                      // UserRepository()
                                      //     .deleteUser(user.id)
                                      //     .then((value) => users.remove(user))
                                      //     .catchError((e) => {
                                      //           ScaffoldMessenger.of(context)
                                      //               .showSnackBar(SnackBar(
                                      //                   content: Text(
                                      //                       "Error during user deletion")))
                                      //         });
                                    });
                                  },
                                )
                              ])),
                            ]),
                        ],
                      ))))
        ]));
  }
}
