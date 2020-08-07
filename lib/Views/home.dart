import 'package:Caisse/main.dart';
import 'package:intl/intl.dart';
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
  int totalMoney = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(widget.title).build(),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            alignment: Alignment.topCenter,
            child: MaterialButton(
              color: Colors.deepOrangeAccent,
              onPressed: () async {
                final List<DateTime> picked =
                    await DateRagePicker.showDatePicker(
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
                    secondDate = picked[1]
                        .add(Duration(hours: 23, minutes: 59, seconds: 59));
                  });
              },
              child: Text("Choisir la période", style: defaultStyle),
            ),
          ),
          if (firstDate != null && secondDate != null)
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      children: [
                        TextSpan(text: "Statistiques entre le "),
                        TextSpan(
                          text: formatDate(firstDate),
                          style: TextStyle(
                            backgroundColor: Colors.orange.withOpacity(0.2),
                          ),
                        ),
                        TextSpan(text: " et le "),
                        TextSpan(
                          text: formatDate(secondDate),
                          style: TextStyle(
                            backgroundColor: Colors.orange.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text("Prestations : " + getData().toString(),
                    style: defaultStyle),
                Text("Total : " + totalMoney.toString() + "€",
                    style: defaultStyle),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMMM y', 'fr_FR').format(date);
  }

  getData() {
    print("first " + firstDate.toString());
    print("second " + secondDate.toString());
    totalNumber = 0;
    totalMoney = 0;
    allServicesList.forEach(
      (element) {
        print(element.date);
        if ((element.date.isAfter(secondDate) &&
                element.date.isBefore(firstDate)) ||
            (element.date.isAfter(firstDate) &&
                element.date.isBefore(secondDate)) ||
            element.date.isAtSameMomentAs(firstDate) ||
            element.date.isAtSameMomentAs(secondDate)) {
          totalNumber++;
          totalMoney += element.service.price;
        }
      },
    );
    return totalNumber;
  }
}
