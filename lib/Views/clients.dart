import 'package:flutter/material.dart';
import 'package:Caisse/Models/client.dart';

import 'add_client.dart';
import 'bottom_bar.dart';

class ClientsPage extends StatefulWidget {
  ClientsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ClientsPageState createState() => _ClientsPageState();
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
              padding: new EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddClientPage(
                      title: "Ajouter un Client ",
                    ),
                  ),
                )
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
              padding: new EdgeInsets.symmetric(vertical: 12.0),
              itemBuilder: (context, index) {
                String currentLetter = getClients()[index].lastName[0];
                Card card = Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: getTile(getClients()[index]),
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
              itemCount: getClients().length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  List<Client> getClients() {
    List<Client> list = makeClients(10);
    list.sort((a, b) => a.lastName.compareTo(b.lastName));
    return list;
  }

  List<Client> makeClients(int count) {
    List<Client> list = new List();
    for (int i = 0; i < count; i++) {
      list.add(new Client("virginie" + i.toString(), "lopez"));
    }
    list.add(new Client("céline", "herve"));
    return list;
  }

  ListTile getTile(Client client) {
    return ListTile(
      title: new Text(
        client.getNameReversed(),
        style: TextStyle(fontSize: 16),
      ),
      trailing: IconButton(
        icon: Icon(Icons.shop_two),
        onPressed: null,
      ),
    );
  }
}
