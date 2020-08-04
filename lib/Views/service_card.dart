import 'package:Caisse/Models/styles.dart';
import 'package:flutter/material.dart';
import 'package:Caisse/Models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  ServiceCard({this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
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
            colors: [
              Color.fromRGBO(225, 210, 241, 100),
              Color.fromRGBO(191, 117, 248, 100)
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }

  Container textWithBackground(String text) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: Text(
          text,
          style: cardPriceStyle,
        ),
      ),
    );
  }
}
