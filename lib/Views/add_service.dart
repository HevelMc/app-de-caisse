import 'package:Caisse/Models/client.dart';
import 'package:Caisse/Views/services.dart';
import 'package:Caisse/main.dart';
import 'package:Caisse/Models/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottom_bar.dart';

class AddServicePage extends StatefulWidget {
  AddServicePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  String name;
  int price;
  int duration;
  bool package = false;
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
                  autofocus: true,
                  autocorrect: false,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    labelText: 'Nom de la Prestation',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Veuillez entrer le nom';
                    return null;
                  },
                  onChanged: (newValue) => this.name = newValue,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    icon: Icon(Icons.euro_symbol),
                    labelText: 'Prix (en euros)',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Veuillez entrer le prix';
                    return null;
                  },
                  onChanged: (newValue) => this.price = int.tryParse(newValue),
                ),
                Row(
                  children: <Widget>[
                    new Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          icon: Icon(Icons.timer),
                          labelText: 'Durée (min.)',
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                        onChanged: (newValue) =>
                            this.duration = int.tryParse(newValue),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: new EdgeInsets.symmetric(horizontal: 10),
                        child: CheckboxListTile(
                          title: const Text(
                            'Forfait',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          value: this.package,
                          onChanged: (val) {
                            setState(() => this.package = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: new EdgeInsets.symmetric(vertical: 40.0),
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
                    padding: new EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        servicesList.add(Service(this.name, this.price,
                            this.duration, this.package));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ServicesPage(title: 'Prestations'),
                          ),
                        );
                      }
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
      bottomNavigationBar: new BottomBar(2),
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
