import 'package:Caisse/Models/client_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Models/data.dart';
import 'Models/client.dart';
import 'Views/home.dart';
import 'Models/service.dart';

List<Service> servicesList = List();
List<Service> selectedList = List();
List<Client> clientsList;
List<ClientService> allServicesList = List();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  servicesList = await DataManager().loadServices();
  clientsList = await DataManager().loadClients();
  allServicesList = await DataManager().loadAllServices();
  await initializeDateFormatting('fr_FR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Caisse',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Utils {
  static openPage(BuildContext context, Widget page, [pop = true]) {
    if (pop)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => page),
          (Route<dynamic> route) => false);
    else
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
  }
}
