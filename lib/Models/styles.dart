import 'package:flutter/material.dart';
import 'package:Caisse/Models/colors.dart';

TextStyle cardNameStyle = TextStyle(
  fontSize: 36,
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
  fontSize: 24,
  color: cardNameColor,
);
