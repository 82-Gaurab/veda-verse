import 'package:flutter/material.dart';
import 'package:vedaverse/features/onboarding/presentation/pages/second_on_boarding_screen.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_progress_bar.dart';

class FirstOnBoardingScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String password;
  final String username;
  const FirstOnBoardingScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),

              MyProgressBar(notProgressFlex: 3),

              SizedBox(height: 50),

              Text(
                "Select your gender",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFF38B120),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 50),

              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_box, color: Color(0xFFFFAE37), size: 40),
                      SizedBox(width: 10),
                      Text("Male", style: TextStyle(fontSize: 25)),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        color: Color(0xFFFFAE37),
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text("Female", style: TextStyle(fontSize: 25)),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        color: Color(0xFFFFAE37),
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text("Others", style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ],
              ),
              Spacer(),

              MyButton(
                text: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondOnBoardingScreen(
                        fullName: fullName,
                        email: email,
                        password: password,
                        username: username,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
