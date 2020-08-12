import 'package:Caisse/main.dart';
import 'package:Caisse/Models/styles.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';

import 'bottom_bar.dart';

class HomePage extends StatefulWidget {
  final String title = "Statistiques";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime firstDate = DateTime.now().add(Duration(days: -7));
  DateTime secondDate = DateTime.now();
  int totalNumber = 0;
  double totalMoney = 0;
  double totalCreditCard;
  double totalCash;
  double totalCheque;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            alignment: Alignment.topCenter,
            child: FlatButton.icon(
              color: Colors.deepOrangeAccent,
              onPressed: () async {
                final List<DateTime> picked = await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: DateTime.now().add(Duration(days: -7)),
                  initialLastDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked.length == 2)
                  setState(() {
                    if (picked[1].isBefore(picked[0])) {
                      DateTime c = picked[0];
                      picked[0] = picked[1];
                      picked[1] = c;
                    }
                    firstDate = picked[0];
                    secondDate = picked[1].add(Duration(hours: 23, minutes: 59, seconds: 59));
                  });
              },
              label: Text("Choisir la période", style: defaultStyle),
              icon: Icon(Icons.date_range, size: 24),
            ),
          ),
          if (firstDate != null && secondDate != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      children: [
                        TextSpan(
                          text: "Statistiques entre le\n",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: formatDate(firstDate),
                          style: TextStyle(
                            backgroundColor: Colors.orange.withOpacity(0.2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "\net le\n",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: formatDate(secondDate),
                          style: TextStyle(
                            backgroundColor: Colors.orange.withOpacity(0.2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: Column(
                    children: [
                      Row(children: [
                        Text("Prestations : "),
                        Spacer(),
                        Text(getData().toString()),
                      ]),
                      Row(children: [Text("Total : "), Spacer(), Text(Utils.formatPrice(totalMoney))]),
                      Row(children: [
                        Text("\nCartes Bancaires : "),
                        Spacer(),
                        Text("\n" + Utils.formatPrice(totalCreditCard))
                      ]),
                      Row(children: [Text("Espèces : "), Spacer(), Text(Utils.formatPrice(totalCash))]),
                      Row(children: [Text("Chèques : "), Spacer(), Text(Utils.formatPrice(totalCheque))]),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }

  String formatDate(DateTime date) {
    return MaterialLocalizations.of(context).formatFullDate(date);
  }

  getData() {
    totalNumber = 0;
    totalMoney = 0;
    totalCreditCard = 0;
    totalCash = 0;
    totalCheque = 0;

    allServicesList.forEach(
      (element) {
        if ((element.date.compareTo(secondDate) > -1 && element.date.compareTo(firstDate) < 1) ||
            (element.date.compareTo(firstDate) > -1 && element.date.compareTo(secondDate) < 1)) {
          totalNumber++;
          double price = (element.newPrice == null) ? element.service.price : element.newPrice;
          totalMoney += price;
          if (element.paymentMethod == "CB") totalCreditCard += price;
          if (element.paymentMethod == "Espèces") totalCash += price;
          if (element.paymentMethod == "Chèque") totalCheque += price;
        }
      },
    );
    return totalNumber;
  }
}
