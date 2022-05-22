import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.teal;
  static final ThemeData primaryTheme = ThemeData(
      primarySwatch: Colors.teal,
      primaryColor: Colors.teal,
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyText2: TextStyle(
          color: Colors.black,
        ),
      ),
      cardColor: Colors.white);
}
