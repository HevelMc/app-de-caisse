import 'package:Caisse/Views/add_to_client.dart';
import 'package:flutter/material.dart';

import '../Models/client.dart';
import 'add_client.dart';
import '../main.dart';
import 'bottom_bar.dart';

class ClientsPage extends StatefulWidget {
  final String title = "Clients";

  @override
  _ClientsPageState createState() => _ClientsPageState();

  static List<Client> getClients() {
    clientsList.sort((a, b) => a.lastName.compareTo(b.lastName));
    return clientsList;
  }
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    String lastLetter = "";
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: Column(
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
                Utils.openPage(
                  context,
                  AddClientPage(),
                  false,
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              itemBuilder: (context, index) {
                String currentLetter =
                    ClientsPage.getClients()[index].lastName[0];
                Card card = Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: getTile(ClientsPage.getClients()[index]),
                );
                if (lastLetter != currentLetter) {
                  lastLetter = currentLetter;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: (index == 0) ? 0 : 20,
                          left: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          currentLetter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      card
                    ],
                  );
                } else {
                  lastLetter = currentLetter;
                  return card;
                }
              },
              itemCount: ClientsPage.getClients().length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  List<Client> makeClients(int count) {
    List<Client> list = List();
    for (int i = 0; i < count; i++) {
      list.add(Client(
        "virginie" + i.toString(),
        "lopez",
        null,
        null,
        null,
        null,
        null,
      ));
    }
    list.add(Client(
      "céline",
      "herve",
      null,
      null,
      null,
      null,
      null,
    ));
    return list;
  }

  ListTile getTile(Client client) {
    return ListTile(
      title: Text(
        client.getNameReversed(),
        style: TextStyle(fontSize: 16),
      ),
      trailing: IconButton(
        icon: Icon(Icons.shop_two),
        onPressed: () => {
          Utils.openPage(
            context,
            AddToClientPage(),
            false,
          ),
        },
      ),
    );
  }
}
