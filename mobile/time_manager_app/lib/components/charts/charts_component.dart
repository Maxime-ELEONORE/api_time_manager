import 'package:flutter/material.dart';

class ChartsComponent extends StatefulWidget {
  const ChartsComponent({Key? key}) : super(key: key);
  @override
  _ChartsComponentState createState() => _ChartsComponentState();
}

class _ChartsComponentState extends State<ChartsComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Charts")),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
        ));
  }
}
