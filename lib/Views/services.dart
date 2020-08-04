import 'package:Caisse/Models/service.dart';
import 'package:Caisse/Views/service_card.dart';
import 'package:Caisse/main.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'add_service.dart';
import 'bottom_bar.dart';

class ServicesPage extends StatefulWidget {
  ServicesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(3, 3),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: FlatButton.icon(
              padding: new EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServicePage(
                      title: "Ajouter une Prestation",
                    ),
                  ),
                )
              },
              label: Text(
                "AJOUTER",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
              icon: Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: new EdgeInsets.only(bottom: 12.0),
              itemBuilder: (context, index) {
                return getCard(getServices()[index]);
              },
              itemCount: getServices().length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }

  List<Service> getServices() {
    return servicesList;
  }

  ServiceCard getCard(Service service) {
    return ServiceCard(
      service: service,
    );
  }
}
