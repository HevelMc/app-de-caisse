import 'package:flutter/material.dart';

import 'services.dart';
import '../Models/colors.dart';
import 'home.dart';
import '../main.dart';
import 'clients.dart';

class BottomBar extends StatefulWidget {
  final int index;

  BottomBar(this.index);

  @override
  _BottomBarState createState() => _BottomBarState(index);
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex;

  _BottomBarState(int index) {
    this._selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this._selectedIndex,
      elevation: 20.0,
      selectedItemColor: Color.fromRGBO(54, 191, 252, 100),
      selectedFontSize: 14,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Statistiques'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Clients'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop_two),
          title: Text('Prestations'),
        ),
      ],
    );
  }

  void _onItemTapped(int i) {
    if (i == 0) Utils.openPage(context, HomePage());
    if (i == 1) Utils.openPage(context, ClientsPage());
    if (i == 2) Utils.openPage(context, ServicesPage());
  }
}

class TopBar {
  final String title;

  TopBar(this.title);

  Widget build() {
    return AppBar(
      title: Text(this.title),
      flexibleSpace: getGradient(),
    );
  }

  Widget buildIcon(IconButton icon) {
    return AppBar(
      title: Text(this.title),
      flexibleSpace: getGradient(),
      leading: Builder(
        builder: (BuildContext context) {
          return icon;
        },
      ),
    );
  }

  Container getGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[gradientLight, gradientDark],
        ),
      ),
    );
  }
}
