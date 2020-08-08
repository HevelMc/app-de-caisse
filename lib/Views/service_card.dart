import 'package:flutter/material.dart';

import '../Models/client_services.dart';
import '../Models/styles.dart';
import '../Models/colors.dart';
import '../Models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final ClientService clientService;

  const ServiceCard({Key key, this.service, this.clientService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Service service =
        (this.service == null) ? this.clientService.service : this.service;
    DateTime date =
        (this.clientService == null) ? null : this.clientService.date;
    return Container(
      margin: EdgeInsets.all(15),
      child: Container(
        height: 200,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              left: 10,
              child: textWithBackground(service.getPrice().toString() + "€"),
            ),
            if (service.package)
              Positioned(
                top: 10,
                right: 10,
                child: textWithBackground("FORFAIT"),
              ),
            if (service.duration != null)
              Positioned(
                bottom: 10,
                left: 10,
                child: textWithBackground(service.getDurationText()),
              ),
            if (date != null)
              Positioned(
                bottom: 10,
                right: 10,
                child: textWithBackground(date.day.toString().padLeft(2, '0') +
                    "/" +
                    date.month.toString().padLeft(2, '0') +
                    "/" +
                    date.year.toString().padLeft(4, '0')),
              ),
            Center(
              child: Text(
                service.getName().toUpperCase(),
                style: (threeParts(service.getName()))
                    ? cardNameStyle.apply(fontSizeFactor: 0.7)
                    : cardNameStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
          gradient: LinearGradient(
            colors: (service.package) ? packageCardColors : basicCardColors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }

  Container textWithBackground(String text) {
    return widgetWithBackground(Text(text, style: cardPriceStyle));
  }

  bool threeParts(String text) {
    RegExp exp = new RegExp(r"(.*\n){2}");
    return exp.hasMatch(text);
  }

  Container widgetWithBackground(Widget widget) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(child: widget),
    );
  }
}
