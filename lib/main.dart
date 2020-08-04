import 'package:Caisse/Views/home.dart';
import 'package:flutter/material.dart';

import 'Models/service.dart';

List<Service> servicesList = new List<Service>();

void main() {
  List<Service> makeServices(int count) {
    List<Service> list = new List();
    for (int i = 0; i < count; i++) {
      list.add(new Service("Test", 30, null, false));
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
      home: HomePage(title: 'Statistiques'),
      debugShowCheckedModeBanner: false,
    );
  }
}
