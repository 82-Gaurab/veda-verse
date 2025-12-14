import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFFFAE37),
      unselectedItemColor: Colors.black,
    ),
  );
}
