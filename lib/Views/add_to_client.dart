import 'package:Caisse/Models/client_services.dart';
import 'package:Caisse/Models/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/client.dart';
import '../Models/service.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'clients.dart';
import 'service_card.dart';
import 'bottom_bar.dart';

class AddToClientPage extends StatefulWidget {
  AddToClientPage({Key key, @required this.client}) : super(key: key);

  final String title = "Ajouter au client";
  final Client client;

  @override
  _AddToClientPageState createState() => _AddToClientPageState(client);
}

class _AddToClientPageState extends State<AddToClientPage> {
  _AddToClientPageState(this.client);

  String paymentMethod = 'Carte bancaire';
  final Client client;
  DateTime date = DateTime.now();
  final _formKey = GlobalKey<FormState>();

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
                      AddServiceToClientPage(client: client),
                      false,
                    ),
                  },
                  label: Text(
                    "Ajouter une prestation",
                    textAlign: TextAlign.center,
                    style: addButton,
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
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  DropdownButton<String>(
                    value: paymentMethod,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 34,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87, fontSize: 14),
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
                key: _formKey,
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
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                icon: Icon(Icons.local_offer),
                                labelText: 'Pourcentage de réduction',
                                labelStyle: TextStyle(fontSize: 14),
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
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
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
                    Container(
                      padding: EdgeInsets.only(left: 10),
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
                        //padding: EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () => {
                          if (_formKey.currentState.validate())
                            {
                              selectedList.forEach((element) {
                                ClientService cService = ClientService(
                                  element,
                                  DateTime.now(),
                                );
                                client.history.add(cService);
                                allServicesList.add(cService);
                              }),
                              selectedList.clear(),
                              DataManager().saveClients(),
                              DataManager().saveAllServices(),
                              Utils.openPage(context, ClientsPage()),
                            }
                        },
                        label: Text(
                          "Valider",
                          textAlign: TextAlign.center,
                          style: addButton,
                        ),
                        icon: Icon(
                          Icons.check,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
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
  final Client client;

  const AddServiceToClientPage({Key key, @required this.client})
      : super(key: key);

  @override
  _AddServiceToClientPageState createState() =>
      _AddServiceToClientPageState(client);
}

class _AddServiceToClientPageState extends State<AddServiceToClientPage> {
  final Client client;

  _AddServiceToClientPageState(this.client);

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
                  fontSize: 18,
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
                      Utils.openPage(context, AddToClientPage(client: client));
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
