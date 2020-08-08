import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/client.dart';
import '../Models/data.dart';
import '../Models/service.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'services.dart';
import 'bottom_bar.dart';

class AddServicePage extends StatefulWidget {
  final Service service;

  const AddServicePage({Key key, this.service}) : super(key: key);

  @override
  _AddServicePageState createState() => _AddServicePageState(service);
}

class _AddServicePageState extends State<AddServicePage> {
  final Service service;
  final _formKey = GlobalKey<FormState>();
  String name;
  int price;
  int duration;
  bool package = false;

  _AddServicePageState(this.service) {
    if (service != null) {
      name = service.name;
      price = service.price;
      duration = service.duration;
      package = service.package;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(service == null ? "Ajouter une prestation" : service.name)
          .build(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: this.name,
                  autofocus: true,
                  autocorrect: false,
                  style: defaultStyle,
                  decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    labelText: 'Nom de la prestation',
                    labelStyle: defaultStyle,
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Veuillez entrer le nom';
                    return null;
                  },
                  onChanged: (newValue) => this.name = newValue,
                ),
                TextFormField(
                  initialValue: price == null ? null : this.price.toString(),
                  keyboardType: TextInputType.number,
                  style: defaultStyle,
                  decoration: InputDecoration(
                    icon: Icon(Icons.euro_symbol),
                    labelText: 'Prix (en euros)',
                    labelStyle: defaultStyle,
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
                        initialValue:
                            duration == null ? null : this.duration.toString(),
                        keyboardType: TextInputType.number,
                        style: defaultStyle,
                        decoration: InputDecoration(
                          icon: Icon(Icons.timer),
                          labelText: 'Durée (min.)',
                          labelStyle: defaultStyle,
                        ),
                        onChanged: (newValue) =>
                            this.duration = int.tryParse(newValue),
                      ),
                    ),
                    Flexible(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: CheckboxListTile(
                            title: const Text(
                              'Forfait',
                              style: TextStyle(
                                fontSize: 16,
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
                        if (this.service == null) {
                          servicesList.add(Service(
                            this.name,
                            this.price,
                            this.duration,
                            this.package,
                          ));
                        } else {
                          service.name = this.name;
                          service.price = this.price;
                          service.duration = this.duration;
                          service.package = this.package;
                        }

                        DataManager().saveServices();
                        Utils.openPage(
                          context,
                          ServicesPage(),
                        );
                      }
                    },
                    label: Text(
                      service == null ? "Ajouter" : "Modifier",
                      textAlign: TextAlign.center,
                      style: service == null ? addButton : editButton,
                    ),
                    icon: Icon(
                      service == null ? Icons.add : Icons.edit,
                      size: 30,
                    ),
                  ),
                ),
                if (this.service != null)
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
                              title: Text("Supprimer le service ?"),
                              content: Text(
                                  "Êtes-vous sur de vouloir supprimer " +
                                      service.getName() +
                                      " ?"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: Text(
                                    "Supprimer",
                                    style: removeButton,
                                  ),
                                  onPressed: () => {
                                    servicesList.remove(service),
                                    DataManager().saveServices(),
                                    Utils.openPage(context, ServicesPage()),
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
