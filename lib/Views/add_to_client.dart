import 'package:Caisse/Models/client_services.dart';
import 'package:Caisse/Models/data.dart';
import 'package:Caisse/Models/pdf.dart';
import 'package:Caisse/Models/service_category.dart';
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
  AddToClientPage({Key key, @required this.client, this.date}) : super(key: key);

  final String title = "Ajouter au client";
  final DateTime date;
  final Client client;

  @override
  _AddToClientPageState createState() => _AddToClientPageState(client, date);
}

class _AddToClientPageState extends State<AddToClientPage> {
  _AddToClientPageState(this.client, DateTime date) {
    if (date == null) date = DateTime.now();
    this.date = date;
  }

  String paymentMethod = 'Carte bancaire';
  final Client client;
  DateTime date;
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
                    Utils.openPage(context, AddServiceToClientPage(client: client, date: date), false),
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
              Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton.icon(
                  icon: Icon(Icons.date_range),
                  label: Text(
                    "Choisir la date",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: (this.date != null) ? this.date : DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    ).then(
                      (value) => setState(
                        () {
                          if (value == null) value = DateTime.now();
                          this.date = value;
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Date : '),
                      TextSpan(
                        text: (((date.day < 10) ? "0" : "") +
                            date.day.toString() +
                            "/" +
                            ((date.month < 10) ? "0" : "") +
                            date.month.toString()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                                if (pct == null) return 'Veuillez entrer un pourcentage';
                                if (pct < 0 || pct > 100) return 'Veuillez entrer un nombre entre 0 et 100';
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
                        onPressed: validateForm,
                        onLongPress: () async => {
                          await Pdf().generateInvoice(client, selectedList, this.date),
                          validateForm(),
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

  validateForm() {
    if (_formKey.currentState.validate()) {
      selectedList.forEach((element) {
        ClientService cService = ClientService(
          element,
          this.date,
        );
        client.history.add(cService);
        allServicesList.add(cService);
      });
      selectedList.clear();
      DataManager().saveClients();
      DataManager().saveAllServices();
      Utils.openPage(context, ClientsPage());
    }
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
  final ServiceCategory category;
  final Client client;
  final DateTime date;

  const AddServiceToClientPage({Key key, @required this.client, this.category, this.date}) : super(key: key);

  @override
  _AddServiceToClientPageState createState() => _AddServiceToClientPageState(client, category, date);
}

class _AddServiceToClientPageState extends State<AddServiceToClientPage> {
  final Client client;
  final ServiceCategory category;
  final DateTime date;

  _AddServiceToClientPageState(this.client, this.category, this.date);

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
                category == null ? "Choisir une catégorie" : "Choisir une prestation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Container card;
                  if (category == null)
                    card = getCardCategory(serviceCategories[index]).build(context);
                  else
                    card = getCard(category.list[index]).build(context);
                  return FlatButton(
                    child: card,
                    onPressed: () {
                      if (category == null) {
                        Utils.openPage(
                            context,
                            AddServiceToClientPage(
                                client: client, category: serviceCategories[index], date: date),
                            false);
                      } else {
                        selectedList.add(category.list[index]);
                        Utils.openPage(context, AddToClientPage(client: client, date: date));
                      }
                    },
                  );
                },
                itemCount: (category == null) ? serviceCategories.length : category.list.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  ServiceCard getCard(Service service) {
    return ServiceCard(service: service);
  }

  ServiceCard getCardCategory(ServiceCategory category) {
    return ServiceCard(category: category);
  }
}
