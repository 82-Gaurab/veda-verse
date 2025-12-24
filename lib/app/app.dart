import 'package:flutter/material.dart';
import 'package:vedaverse/screen/splash_screen.dart';
import 'package:vedaverse/app/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen(),
    );
  }
}
