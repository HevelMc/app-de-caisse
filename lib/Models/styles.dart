import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle cardNameStyle = TextStyle(
  fontSize: 30,
  color: cardNameColor,
  shadows: <Shadow>[
    Shadow(
      color: Colors.black.withOpacity(0.55),
      offset: Offset(2, 4),
      blurRadius: 6,
    ),
  ],
);

TextStyle cardPriceStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: cardNameColor,
);

TextStyle addButton = TextStyle(fontSize: 18, color: Colors.green);
TextStyle editButton = TextStyle(fontSize: 18, color: Colors.black);
TextStyle removeButton = TextStyle(fontSize: 18, color: Colors.red);
TextStyle defaultStyle = TextStyle(fontSize: 16);
