import 'package:Caisse/Views/add_client.dart';
import 'package:flutter/material.dart';

import '../Models/data.dart';
import '../Models/client.dart';
import '../Models/client_services.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'add_to_client.dart';
import 'service_card.dart';
import 'bottom_bar.dart';

class ClientPage extends StatefulWidget {
  final Client client;

  ClientPage(this.client);

  @override
  _ClientPageState createState() => _ClientPageState(client);
}

class _ClientPageState extends State<ClientPage> {
  final Client client;

  _ClientPageState(this.client);

  @override
  Widget build(BuildContext context) {
    List<ClientService> sortedHistory = client.history;
    sortedHistory.sort((a, b) => -a.date.compareTo(b.date));
    return Scaffold(
      appBar: TopBar(client.getName()).build(),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 6, left: 10, right: 10),
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
              padding: EdgeInsets.only(bottom: 6, top: 6, left: 10, right: 10),
              onPressed: () => {
                Utils.openPage(
                  context,
                  AddClientPage(client),
                  false,
                ),
              },
              label: Text(
                "Modifier les informations",
                textAlign: TextAlign.center,
                style: editButton,
              ),
              icon: Icon(
                Icons.edit,
                size: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
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
              padding: EdgeInsets.all(10),
              onPressed: () => {
                Utils.openPage(
                  context,
                  AddToClientPage(client: client),
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
                size: 35,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 12.0),
              itemBuilder: (context, index) {
                return getCard(sortedHistory[index]);
              },
              itemCount: sortedHistory.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  FlatButton getCard(ClientService clientService) {
    return FlatButton(
      onPressed: null,
      onLongPress: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Supprimer cette prestation de l'historique ?"),
              content: Text("Êtes-vous sur de vouloir supprimer la prestation " +
                  clientService.service.name +
                  " de l'historique de " +
                  client.getName() +
                  " ?"),
              actions: <Widget>[
                new FlatButton(
                  child: Text(
                    "Supprimer",
                    style: removeButton,
                  ),
                  onPressed: () => {
                    client.history.remove(clientService),
                    allServicesList.remove(clientService),
                    DataManager().saveClients(),
                    Utils.openPage(context, ClientPage(client)),
                  },
                ),
              ],
            );
          }),
      child: ServiceCard(clientService: clientService),
    );
  }
}
