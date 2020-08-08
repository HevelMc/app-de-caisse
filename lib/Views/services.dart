import 'package:Caisse/Models/service_category.dart';
import 'package:flutter/material.dart';

import '../Models/service.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'service_card.dart';
import 'add_service.dart';
import 'bottom_bar.dart';

class ServicesPage extends StatefulWidget {
  final String title = "Prestations";
  final ServiceCategory category;

  const ServicesPage({Key key, this.category}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState(category);
}

class _ServicesPageState extends State<ServicesPage> {
  final ServiceCategory category;

  _ServicesPageState(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(category == null ? widget.title : category.name).build(),
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
                  AddServicePage(category: category),
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
                if (category == null)
                  return getCardCategory(serviceCategories[index]);
                else
                  return getCard(category.list[index]);
              },
              itemCount: category == null ? serviceCategories.length : category.list.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }

  FlatButton getCard(Service service) {
    return FlatButton(
      child: ServiceCard(service: service),
      onPressed: null,
      onLongPress: () => Utils.openPage(
        context,
        AddServicePage(service: service),
      ),
    );
  }

  FlatButton getCardCategory(ServiceCategory category) {
    return FlatButton(
      child: ServiceCard(category: category),
      onPressed: () => Utils.openPage(
        context,
        ServicesPage(category: category),
      ),
      onLongPress: () => Utils.openPage(
        context,
        AddServicePage(category: category, modifyCategory: true),
      ),
    );
  }
}
