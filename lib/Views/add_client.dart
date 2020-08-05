import 'package:Caisse/Views/clients.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/client.dart';
import '../main.dart';
import 'bottom_bar.dart';

class AddClientPage extends StatefulWidget {
  final String title = "Ajouter un client";

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String lastName;
  String email;
  int number;
  int postCode;
  DateTime birthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
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
                    inputFormatters: [CapitalizeTextFormatter()],
                    autofocus: true,
                    autocorrect: false,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Prénom',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Veuillez entrer le prénom';
                      return null;
                    },
                    onChanged: (newValue) => this.firstName = newValue,
                  ),
                  TextFormField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    autocorrect: false,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      labelText: 'Nom de famille',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Veuillez entrer le nom';
                      return null;
                    },
                    onChanged: (newValue) => this.lastName = newValue,
                  ),
                  TextFormField(
                    autocorrect: false,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    onChanged: (newValue) => this.email = newValue,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'Numéro',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    onChanged: (newV) => this.number = int.tryParse(newV),
                  ),
                  TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(Icons.folder),
                      labelText: 'Code Postal',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    onChanged: (newV) => this.postCode = int.tryParse(newV),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton.icon(
                      icon: Icon(Icons.cake),
                      label: Text(
                        "Date d'anniversaire",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
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
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Anniversaire : '),
                          TextSpan(
                            text: (birthday != null)
                                ? (((birthday.day < 10) ? "0" : "") +
                                    birthday.day.toString() +
                                    "/" +
                                    ((birthday.month < 10) ? "0" : "") +
                                    birthday.month.toString())
                                : "?",
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
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      onPressed: () => {
                        ClientsPage.getClients().add(
                          Client(
                              firstName,
                              lastName,
                              email,
                              number,
                              postCode,
                              (birthday != null) ? birthday.day : null,
                              (birthday != null) ? birthday.month : null),
                        ),
                        Utils.openPage(
                          context,
                          ClientsPage(),
                        ),
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
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
