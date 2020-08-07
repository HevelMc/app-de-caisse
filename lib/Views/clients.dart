import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:Caisse/Views/add_to_client.dart';
import 'package:flutter/material.dart';

import '../Models/client.dart';
import '../Models/styles.dart';
import '../main.dart';
import 'add_client.dart';
import 'bottom_bar.dart';
import 'client.dart';

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
  TextEditingController searchController = TextEditingController();
  List<Client> clients = [];

  @override
  void initState() {
    filterList();
    searchController.addListener(() {
      filterList();
    });
    super.initState();
  }

  filterList() {
    List<Client> clients = [];
    clients.addAll(clientsList);
    if (searchController.text.isNotEmpty) {
      clients.retainWhere((client) => client
          .getName()
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
    }
    setState(() {
      this.clients = clients;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> strList = [];
    clients.forEach((element) {
      strList.add(element.getNameReversed());
    });

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
                  AddClientPage(null),
                  false,
                ),
              },
              label: Text(
                "Ajouter",
                textAlign: TextAlign.center,
                style: addButton,
              ),
              icon: Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: AlphabetListScrollView(
              strList: strList,
              indexedHeight: (i) {
                return 80;
              },
              keyboardUsage: true,
              showPreview: true,
              itemBuilder: (context, index) {
                FlatButton card = FlatButton(
                  padding: EdgeInsets.only(left: 20, right: 50),
                  onPressed: () => Utils.openPage(
                      context, ClientPage(clients[index]), false),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: getTile(clients[index]),
                  ),
                );
                return card;
              },
              headerWidgetList: <AlphabetScrollListHeader>[
                AlphabetScrollListHeader(
                  widgetList: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffix: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          labelText: "Rechercher",
                        ),
                      ),
                    )
                  ],
                  icon: Icon(Icons.search),
                  indexedHeaderHeight: (index) => 80,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  ListTile getTile(Client client) {
    return ListTile(
      title: Text(
        client.getNameReversed(),
        style: defaultStyle,
      ),
      trailing: IconButton(
        icon: Icon(Icons.shop_two),
        onPressed: () => {
          Utils.openPage(
            context,
            AddToClientPage(client: client),
            false,
          ),
        },
      ),
    );
  }
}
