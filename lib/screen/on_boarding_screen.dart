import 'package:flutter/material.dart';
import 'package:vedaverse/widgets/my_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("On Boarding 1"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(13),
        child: Column(
          children: [
            MyButton(text: "test", onPressed: () {}, color: Colors.blue),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
            MyButton(text: "test", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
