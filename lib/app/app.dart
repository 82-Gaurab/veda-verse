import 'package:flutter/material.dart';
import 'package:vedaverse/features/splash/presentation/pages/splash_screen.dart';
import 'package:vedaverse/app/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
