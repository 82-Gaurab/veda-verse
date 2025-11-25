import 'package:flutter/material.dart';
import 'package:vedaverse/screen/second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() async {
    super.initState();
    await Future.delayed(Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => SecondScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/images/logo.png"),
            Image.asset("assets/images/title.png"),
          ],
        ),
      ),
    );
  }
}
