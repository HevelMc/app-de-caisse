import 'dart:math';

import 'package:flutter/material.dart';

import 'Models/client.dart';
import 'Views/home.dart';
import 'Models/service.dart';

List<Service> servicesList = List();
List<Service> selectedList = List();
List<Client> clientsList = List();

void main() {
  List<Service> makeServices(int count) {
    List<Service> list = List();
    for (int i = 0; i < count; i++) {
      list.add(Service("Test", 30, null, Random().nextBool()));
    }
    return list;
  }

  servicesList.addAll(makeServices(5));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Caisse',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Utils {
  static void openPage(BuildContext context, Widget page, [pop = true]) {
    if (pop) Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
