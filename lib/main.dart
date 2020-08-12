import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Models/client_services.dart';
import 'Models/service_category.dart';
import 'Models/data.dart';
import 'Models/client.dart';
import 'Views/home.dart';
import 'Models/service.dart';

List<ServiceCategory> serviceCategories = List();
List<Service> selectedList = List();
List<Client> clientsList;
List<ClientService> allServicesList = List();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceCategories = await DataManager().loadCategories();
  clientsList = await DataManager().loadClients();
  allServicesList = await DataManager().loadAllServices();
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', ''), const Locale('fr', 'FR')],
    );
  }
}

class Utils {
  static openPage(BuildContext context, Widget page, [pop = true]) {
    if (pop)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    else
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
  }

  static String formatPrice([double price, bool withSpace = true]) {
    String priceText;
    if (price.roundToDouble() == price)
      priceText = price.round().toString();
    else
      priceText = price.toStringAsFixed(2);
    return priceText + (withSpace ? " " : "") + "€";
  }
}
