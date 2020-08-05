import 'package:flutter/material.dart';

import 'service_card.dart';
import '../Models/service.dart';

import 'bottom_bar.dart';

class HomePage extends StatefulWidget {
  final String title = "Statistiques";

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
          service: Service("Kobido", 40, null, false),
        ),
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}
