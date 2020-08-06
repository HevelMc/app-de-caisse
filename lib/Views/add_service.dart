import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/client.dart';
import '../Models/data.dart';
import '../main.dart';
import '../Models/service.dart';
import 'services.dart';
import 'bottom_bar.dart';

class AddServicePage extends StatefulWidget {
  final String title = "Ajouter une prestation";

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
      appBar: TopBar(widget.title).build(),
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
                    labelText: 'Nom de la prestation',
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
                    Flexible(
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
                        margin: EdgeInsets.symmetric(horizontal: 10),
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
                  margin: EdgeInsets.symmetric(vertical: 40.0),
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        servicesList.add(Service(
                          this.name,
                          this.price,
                          this.duration,
                          this.package,
                        ));
                        DataManager().saveServices();
                        Utils.openPage(
                          context,
                          ServicesPage(),
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
      bottomNavigationBar: BottomBar(2),
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
