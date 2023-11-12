import 'package:flutter/material.dart';
import 'package:time_manager_app/pages/main_component.dart';
import 'package:time_manager_app/repository/session_repository.dart';
import 'package:time_manager_app/service/session_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late String _email = "test@test.fr";
  late String _password = "password";
  SessionService sessionService = SessionService();
  SessionRepository sessionRepository = SessionRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(child: Text("Login")),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Time Manager", style: TextStyle(fontSize: 30)),
              ),
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/logo.png")),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 50),
                child: TextField(
                  decoration: const InputDecoration(labelText: "Email"),
                  onChanged: (value) => _email = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: TextField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onChanged: (value) => _password = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  child: const Text("Sign in"),
                  onPressed: () {
                    if (validateEmailAndPassword(_email, _password)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged in!")));
                      sessionRepository.signIn(_email, _password).then((value) {
                        sessionService.login();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainComponentView())).catchError(
                            (e) => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Sign in error"))));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Invalide email or password")));
                    }
                  },
                ),
              ),
            ]),
          ),
        ));
  }

  bool validateEmailAndPassword(String email, String password) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }
}
