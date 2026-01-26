import 'package:flutter/material.dart';
import 'package:vedaverse/app/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 25),
        displayMedium: TextStyle(fontSize: 18),
      ),

      scaffoldBackgroundColor: AppColors.background,
      fontFamily: "Bricolage",

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFFAE37),
        unselectedItemColor: Color.fromARGB(255, 110, 110, 110),
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: TextStyle(fontSize: 18),
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
}
