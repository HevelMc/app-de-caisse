import 'package:Caisse/Models/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottom_bar.dart';

class AddClientPage extends StatefulWidget {
  AddClientPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime birthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).buildIcon(IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: "Retour",
      )),
      body: Container(
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
                ),
                TextFormField(
                  autocorrect: false,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Numéro',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
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
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
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
                      ).then((value) => this.birthday = value);
                    },
                  ),
                ),
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
                    padding:
                        new EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    onPressed: () => {},
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
      bottomNavigationBar: new BottomBar(1),
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
