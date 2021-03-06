import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/data.dart';
import '../Models/client.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'client.dart';
import 'clients.dart';
import 'bottom_bar.dart';

class AddClientPage extends StatefulWidget {
  final Client client;
  AddClientPage(this.client);

  @override
  _AddClientPageState createState() => _AddClientPageState(client);
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  Client client;
  String firstName;
  String lastName;
  String email;
  int number;
  int postCode;
  DateTime birthday;

  _AddClientPageState(Client client) {
    this.client = client;
    if (client != null) {
      this.firstName = client.firstName;
      this.lastName = client.lastName;
      this.email = client.email;
      this.number = client.number;
      this.postCode = client.postcode;
      if (client.birthDay != null && client.birthMonth != null)
        this.birthday = DateTime(
          DateTime.now().year,
          client.birthMonth,
          client.birthDay,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar((client == null) ? "Ajouter un client" : client.getName()).build(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: this.firstName,
                    inputFormatters: [CapitalizeTextFormatter()],
                    autofocus: true,
                    autocorrect: false,
                    style: defaultStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Prénom',
                      labelStyle: defaultStyle,
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Veuillez entrer le prénom';
                      return null;
                    },
                    onChanged: (newValue) => this.firstName = newValue,
                  ),
                  TextFormField(
                    initialValue: this.lastName,
                    inputFormatters: [UpperCaseTextFormatter()],
                    autocorrect: false,
                    style: defaultStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      labelText: 'Nom de famille',
                      labelStyle: defaultStyle,
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Veuillez entrer le nom';
                      return null;
                    },
                    onChanged: (newValue) => this.lastName = newValue,
                  ),
                  TextFormField(
                    initialValue: this.email,
                    autocorrect: false,
                    style: defaultStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                      labelStyle: defaultStyle,
                    ),
                    onChanged: (newValue) => this.email = newValue,
                  ),
                  TextFormField(
                    initialValue: (this.number == null) ? null : this.number.toString().padLeft(10, '0'),
                    keyboardType: TextInputType.number,
                    style: defaultStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'Numéro',
                      labelStyle: defaultStyle,
                    ),
                    onChanged: (newV) => this.number = int.tryParse(newV),
                  ),
                  TextFormField(
                    initialValue: (this.postCode == null) ? null : this.postCode.toString().padLeft(5, '0'),
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    style: defaultStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.folder),
                      labelText: 'Code Postal',
                      labelStyle: defaultStyle,
                    ),
                    onChanged: (newV) => this.postCode = int.tryParse(newV),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton.icon(
                      icon: Icon(Icons.cake),
                      label: Text(
                        "Date d'anniversaire",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: (this.birthday != null) ? this.birthday : DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            Duration(days: 364, hours: 4),
                          ),
                        ).then((value) => setState(() {
                              this.birthday = value;
                            }));
                      },
                    ),
                  ),
                  if (birthday != null)
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Anniversaire : '),
                            TextSpan(
                              text: (birthday.day.toString().padLeft(2, '0') +
                                  "/" +
                                  birthday.month.toString().padLeft(2, '0')),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        if (_formKey.currentState.validate())
                          {
                            if (client == null)
                              {
                                client = Client(
                                    firstName,
                                    lastName,
                                    email,
                                    number,
                                    postCode,
                                    (birthday != null) ? birthday.day : null,
                                    (birthday != null) ? birthday.month : null),
                                ClientsPage.getClients().add(client),
                              }
                            else
                              {
                                client.firstName = this.firstName,
                                client.lastName = this.lastName,
                                client.email = this.email,
                                client.number = this.number,
                                client.postcode = this.postCode,
                                client.birthDay = (birthday != null) ? birthday.day : null,
                                client.birthMonth = (birthday != null) ? birthday.month : null,
                              },
                            DataManager().saveClients(),
                            Utils.openPage(context, ClientPage(client)),
                          },
                      },
                      label: Text(
                        (client == null) ? "Ajouter" : "Modifier",
                        textAlign: TextAlign.center,
                        style: client == null ? addButton : editButton,
                      ),
                      icon: Icon(
                        (client == null) ? Icons.add : Icons.edit,
                        size: 30,
                      ),
                    ),
                  ),
                  if (client != null)
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
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Supprimer le client ?"),
                                content:
                                    Text("Êtes-vous sur de vouloir supprimer " + client.getName() + " ?"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: Text(
                                      "Supprimer",
                                      style: removeButton,
                                    ),
                                    onPressed: () => {
                                      clientsList.remove(client),
                                      DataManager().saveClients(),
                                      Utils.openPage(context, ClientsPage()),
                                    },
                                  ),
                                ],
                              );
                            }),
                        label: Text(
                          "Supprimer",
                          textAlign: TextAlign.center,
                          style: removeButton,
                        ),
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
