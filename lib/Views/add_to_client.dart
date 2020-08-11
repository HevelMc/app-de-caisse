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
  AddToClientPage({Key key, @required this.client, this.date, this.discounts, this.paymentMethod})
      : super(key: key);

  final String title = "Ajouter au client";
  final DateTime date;
  final Client client;
  final List<int> discounts;
  final String paymentMethod;

  @override
  _AddToClientPageState createState() => _AddToClientPageState(client, date, discounts, paymentMethod);
}

class _AddToClientPageState extends State<AddToClientPage> {
  _AddToClientPageState(this.client, DateTime date, List<int> discounts, String paymentMethod) {
    if (date == null) date = DateTime.now();
    this.date = date;
    if (discounts == null) discounts = [];
    this.discounts = discounts;
    if (paymentMethod == null) paymentMethod = '';
    this.paymentMethod = paymentMethod;
  }

  String paymentMethod;
  final Client client;
  DateTime date;
  final _formKey = GlobalKey<FormState>();
  List<int> discounts;
  final Map<String, IconData> paymentMethodIcons = {
    '': Icons.payments,
    'CB': Icons.credit_card,
    'Espèces': Icons.money,
    'Chèque': Icons.receipt
  };

  @override
  Widget build(BuildContext context) {
    int index = 0;
    selectedList.forEach((element) {
      if (discounts.length < selectedList.length) discounts.add(0);
      if (discounts.elementAt(index) == null) discounts[index] = 0;
      index++;
    });
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                    child: IconButton(
                      onPressed: () => {
                        Utils.openPage(
                          context,
                          AddServiceToClientPage(
                              client: client, date: date, discounts: discounts, paymentMethod: paymentMethod),
                          false,
                        ),
                      },
                      icon: Icon(Icons.add, size: 30),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                    child: IconButton(
                      onPressed: () => {
                        showDatePicker(
                          context: context,
                          locale: Localizations.localeOf(context),
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
                        )
                      },
                      icon: Icon(Icons.calendar_today, size: 30),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                    child: DropdownButton<String>(
                      value: paymentMethod,
                      iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      onChanged: (String newValue) {
                        setState(() {
                          paymentMethod = newValue;
                        });
                      },
                      items: <String>['', 'CB', 'Espèces', 'Chèque']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 20),
                                child: Icon(paymentMethodIcons[value], size: 25),
                              ),
                              Text(value)
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
                              initialValue: (discounts.length <= index || discounts.elementAt(index) == null)
                                  ? "0"
                                  : discounts[index].toString(),
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                icon: Icon(Icons.local_offer),
                                labelText: 'Pourcentage de réduction',
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              autovalidate: true,
                              validator: (value) {
                                int pct = int.tryParse(value);
                                if (pct == null) return 'Veuillez entrer un pourcentage';
                                if (pct < 0 || pct > 100) return 'Veuillez entrer un nombre entre 0 et 100';
                                return null;
                              },
                              onChanged: (newValue) {
                                if (_formKey.currentState.validate())
                                  setState(() {
                                    discounts[index] = int.parse(newValue);
                                  });
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
              if (selectedList.length > 0)
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
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Total : '),
                              TextSpan(
                                text: getTotal().toStringAsFixed(2),
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
                            await Pdf().generateInvoice(client, selectedList, this.date, context),
                            validateForm(),
                          },
                          label: Text(
                            "Encaisser",
                            textAlign: TextAlign.center,
                            style: addButton,
                          ),
                          icon: Icon(
                            Icons.shop_two_outlined,
                            size: 30,
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
      if (paymentMethod != '') {
        selectedList.forEach((element) {
          ClientService cService = ClientService(
            element,
            this.date,
            getTotal(),
          );
          client.history.add(cService);
          allServicesList.add(cService);
        });
        selectedList.clear();
        DataManager().saveClients();
        DataManager().saveAllServices();
        Utils.openPage(context, ClientsPage());
      } else
        return "Vous devez choisir le moyen de règlement !";
    }
  }

  double getTotal() {
    double total = 0;
    int index = 0;
    selectedList.forEach((element) {
      double price = (element.price * (1 - discounts[index] / 100));
      total += price;
      index++;
    });
    return total;
  }
}

class AddServiceToClientPage extends StatefulWidget {
  final String title = "Ajouter une prestation";
  final ServiceCategory category;
  final Client client;
  final DateTime date;
  final List<int> discounts;
  final String paymentMethod;

  const AddServiceToClientPage(
      {Key key, @required this.client, this.category, this.date, this.discounts, this.paymentMethod})
      : super(key: key);

  @override
  _AddServiceToClientPageState createState() =>
      _AddServiceToClientPageState(client, category, date, discounts, paymentMethod);
}

class _AddServiceToClientPageState extends State<AddServiceToClientPage> {
  final Client client;
  final ServiceCategory category;
  final DateTime date;
  final List<int> discounts;
  final paymentMethod;

  _AddServiceToClientPageState(this.client, this.category, this.date, this.discounts, this.paymentMethod);

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
                                client: client,
                                category: serviceCategories[index],
                                date: date,
                                discounts: discounts,
                                paymentMethod: paymentMethod),
                            false);
                      } else {
                        selectedList.add(category.list[index]);
                        Utils.openPage(
                            context,
                            AddToClientPage(
                                client: client,
                                date: date,
                                discounts: discounts,
                                paymentMethod: paymentMethod));
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
