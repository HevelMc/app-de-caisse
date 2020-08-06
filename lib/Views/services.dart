import 'package:flutter/material.dart';

import '../Models/service.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'service_card.dart';
import 'add_service.dart';
import 'bottom_bar.dart';

class ServicesPage extends StatefulWidget {
  final String title = "Prestations";

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
            margin: EdgeInsets.symmetric(vertical: 20.0),
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
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              onPressed: () => {
                Utils.openPage(
                  context,
                  AddServicePage(),
                  false,
                ),
              },
              label: Text(
                "Ajouter",
                textAlign: TextAlign.center,
                style: addButton,
              ),
              icon: Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 12.0),
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
