import 'package:flutter/material.dart';
import 'package:vedaverse/screen/splash_screen.dart';
import 'package:vedaverse/theme/theme_data.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen(),
    ),
  );
}
