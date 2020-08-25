import 'package:Caisse/Models/service_category.dart';
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
  final ServiceCategory category;
  final bool modifyCategory;

  const AddServicePage({Key key, this.service, this.category, this.modifyCategory}) : super(key: key);

  @override
  _AddServicePageState createState() => _AddServicePageState(service, category, modifyCategory);
}

class _AddServicePageState extends State<AddServicePage> {
  final Service service;
  final ServiceCategory category;
  final _formKey = GlobalKey<FormState>();
  String name;
  double price;
  int duration;
  bool package = false;
  bool modifyCategory = false;

  _AddServicePageState(this.service, this.category, modify) {
    if (service != null) {
      name = service.name;
      price = service.price;
      duration = service.duration;
      package = service.package;
    } else if (category != null && modify == true) {
      name = category.name;
    }
    if (modify == true) modifyCategory = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(service != null
              ? service.name
              : (category == null
                  ? "Ajouter une catégorie"
                  : modifyCategory ? category.name : "Ajouter une prestation"))
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
                    labelText: (category == null) ? 'Nom de la catégorie ' : 'Nom de la prestation',
                    labelStyle: defaultStyle,
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Veuillez entrer le nom';
                    return null;
                  },
                  onChanged: (newValue) => this.name = newValue,
                ),
                if (!modifyCategory && category != null)
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
                    onChanged: (newValue) => this.price = double.tryParse(newValue),
                  ),
                if (!modifyCategory && category != null)
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          initialValue: duration == null ? null : this.duration.toString(),
                          keyboardType: TextInputType.number,
                          style: defaultStyle,
                          decoration: InputDecoration(
                            icon: Icon(Icons.timer),
                            labelText: 'Durée (min.)',
                            labelStyle: defaultStyle,
                          ),
                          onChanged: (newValue) => this.duration = int.tryParse(newValue),
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
                                  fontSize: 15,
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
                        if (category == null && !modifyCategory)
                          serviceCategories.add(ServiceCategory(this.name));
                        else if (category != null && modifyCategory) {
                          category.name = this.name;
                        } else if (this.service == null) {
                          category.list.add(Service(
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
                        sortServices();

                        DataManager().saveCategories();
                        Utils.openPage(
                          context,
                          ServicesPage(category: category),
                        );
                      }
                    },
                    label: Text(
                      service != null || modifyCategory == true ? "Modifier" : "Ajouter",
                      textAlign: TextAlign.center,
                      style: service != null || modifyCategory == true ? editButton : addButton,
                    ),
                    icon: Icon(
                      service != null || modifyCategory == true ? Icons.edit : Icons.add,
                      size: 30,
                    ),
                  ),
                ),
                if (service != null || modifyCategory == true)
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
                              title: Text((modifyCategory)
                                  ? "Supprimer la catégorie ?"
                                  : "Supprimer la prestation ?"),
                              content: Text("Êtes-vous sur de vouloir supprimer " + name + " ?"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: Text(
                                    "Supprimer",
                                    style: removeButton,
                                  ),
                                  onPressed: () => {
                                    if (modifyCategory)
                                      serviceCategories.remove(category)
                                    else
                                      category.list.remove(service),
                                    DataManager().saveCategories(),
                                    Utils.openPage(
                                        context, ServicesPage(category: modifyCategory ? null : category)),
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

  void sortServices() {
    serviceCategories.forEach((element) => element.list.sort((a, b) => a.price.compareTo(b.price)));
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
