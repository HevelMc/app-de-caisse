import 'package:flutter/material.dart';

import '../Models/styles.dart';
import '../Models/colors.dart';
import '../Models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  ServiceCard({this.service});

  @override
  Widget build(BuildContext context) {
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
            Positioned(
              bottom: 10,
              right: 10,
              child: widgetWithBackground(Icon(
                Icons.delete,
                color: Colors.redAccent,
              )),
            ),
            Center(
              child: Text(
                service.getName().toUpperCase(),
                style: cardNameStyle,
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
    return widgetWithBackground(Text(
      text,
      style: cardPriceStyle,
    ));
  }

  Container widgetWithBackground(Widget widget) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: widget,
      ),
    );
  }
}
