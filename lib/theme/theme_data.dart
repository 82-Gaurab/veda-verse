import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: "Bricolage",

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFFFAE37),
      unselectedItemColor: Colors.black,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFAE37)),
    ),

    inputDecorationTheme: InputDecorationThemeData(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFAE37)),
      ),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFAE37), width: 2),
      ),
    ),
  );
}
