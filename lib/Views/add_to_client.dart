import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/service.dart';
import 'service_card.dart';
import '../main.dart';
import 'bottom_bar.dart';

class AddToClientPage extends StatefulWidget {
  AddToClientPage({Key key}) : super(key: key);

  final String title = "Ajouter au client";

  @override
  _AddToClientPageState createState() => _AddToClientPageState();
}

class _AddToClientPageState extends State<AddToClientPage> {
  String paymentMethod = 'Carte bancaire';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Column(
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
                      AddServiceToClientPage(),
                      false,
                    ),
                  },
                  label: Text(
                    "Ajouter une prestation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                  icon: Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Moyen de règlement : ",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  DropdownButton<String>(
                    value: paymentMethod,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 34,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    onChanged: (String newValue) {
                      setState(() {
                        paymentMethod = newValue;
                      });
                    },
                    items: <String>['Carte bancaire', 'Espèces', 'Chèque']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Form(
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      Container card = ServiceCard(
                        service: selectedList[index],
                      ).build(context);
                      return Column(
                        children: <Widget>[
                          card,
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 50,
                            ),
                            child: TextFormField(
                              initialValue: "0",
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                icon: Icon(Icons.local_offer),
                                labelText: 'Pourcentage de réduction',
                                labelStyle: TextStyle(fontSize: 20),
                              ),
                              validator: (value) {
                                int pct = int.tryParse(value);
                                if (pct == null)
                                  return 'Veuillez entrer un pourcentage';
                                if (pct < 0 || pct > 100)
                                  return 'Veuillez entrer un nombre entre 0 et 100';
                                return null;
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: selectedList.length,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Total : '),
                      TextSpan(
                        text: getTotal().toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " €"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  int getTotal() {
    int total = 0;
    selectedList.forEach((element) {
      total += element.price;
    });
    return total;
  }
}

class AddServiceToClientPage extends StatefulWidget {
  final String title = "Ajouter une prestation";

  @override
  _AddServiceToClientPageState createState() => _AddServiceToClientPageState();
}

class _AddServiceToClientPageState extends State<AddServiceToClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Choisir une prestation",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Container card = getCard(servicesList[index]).build(context);
                  return FlatButton(
                    child: card,
                    onPressed: () {
                      selectedList.add(servicesList[index]);
                      Utils.openPage(context, AddToClientPage());
                    },
                  );
                },
                itemCount: servicesList.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }

  ServiceCard getCard(Service service) {
    return ServiceCard(service: service);
  }
}
