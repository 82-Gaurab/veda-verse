import 'package:flutter/material.dart';
import 'package:vedaverse/widgets/my_button.dart';
import 'package:vedaverse/screen/login_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/book-stack.jpg", height: 500),
            Text(
              "Enjoy your reading journey through us",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),

            MyButton(
              text: "Continue",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
