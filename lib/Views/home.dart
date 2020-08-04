import 'package:flutter/material.dart';
import 'package:Caisse/Views/service_card.dart';
import 'package:Caisse/Models/service.dart';

import 'bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: Center(
        //Tests
        child: ServiceCard(
          service: Service("Kobido", 40),
        ),
      ),
      bottomNavigationBar: new BottomBar(0),
    );
  }
}
