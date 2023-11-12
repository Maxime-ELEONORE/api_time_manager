import 'package:flutter/material.dart';
import 'package:time_manager_app/models/user.dart';

class CreateUserComponent extends StatefulWidget {
  final bool isProfile;
  final User user;
  const CreateUserComponent(
      {super.key, required this.user, this.isProfile = false});

  @override
  State<StatefulWidget> createState() => CreateUserComponentState();
}

class CreateUserComponentState extends State<CreateUserComponent> {
  late User user;
  late User initialUser;
  List<String> dropdownValues = <String>['User', 'Super User', 'User Manager'];

  @override
  void initState() {
    super.initState();
    user = User.copy(widget.user);
    initialUser = User.copy(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(child: displayTitle()),
            automaticallyImplyLeading: widget.isProfile == true ? false : true,
            backgroundColor: widget.isProfile == true
                ? Colors.transparent
                : Theme.of(context).colorScheme.inversePrimary),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle, size: 100),
                    TextField(
                      controller: TextEditingController(text: user.username),
                      decoration: const InputDecoration(labelText: "Username"),
                      onChanged: (value) => user.username = value,
                    ),
                    TextField(
                      controller: TextEditingController(text: user.email),
                      decoration: const InputDecoration(labelText: "Email"),
                      onChanged: (value) => user.email = value,
                    ),
                    // displayPasswordField(),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropdownButton<String>(
                          value: user.role,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            width: double.infinity,
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              user.role = value!;
                            });
                          },
                          items: dropdownValues
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          child: const Text("Save"),
                                          onPressed: () {
                                            print(user.email);
                                            print(initialUser.email);
                                            setState(() {
                                              if (user.id == "") {
                                                // call http create
                                              } else {
                                                //call http update
                                              }
                                            });
                                          },
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            setState(() {
                                              user = User.copy(initialUser);
                                            });
                                          },
                                        ))
                                  ],
                                )))))
                  ]),
            )));
  }

  Widget displayTitle() {
    if (widget.isProfile == true) {
      return const Text("Profile");
    } else if (user.id == "") {
      return const Text("Create User");
    }
    return const Text("Update User");
  }

  // Widget displayPasswordField() {
  //   if (user.id == "") {
  //     return TextField(
  //       controller: TextEditingController(text: user),
  //       decoration: const InputDecoration(labelText: "Password"),
  //       onChanged: (value) => user.password = value,
  //     );
  //   }
  // }
}
