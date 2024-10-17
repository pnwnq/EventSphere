import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      accentColor: Colors.lightBlueAccent,
      scaffoldBackgroundColor: Colors.lightBlue[50],
      appBarTheme: AppBarTheme(
        color: Colors.blue[700],
        elevation: 0,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        bodyText1: TextStyle(color: Colors.blue[800]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue[600],
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
