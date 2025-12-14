import 'package:flutter/material.dart';
import 'package:vedaverse/screen/final_on_boarding_screen.dart';
import 'package:vedaverse/widgets/my_button.dart';
import 'package:vedaverse/widgets/my_progress_bar.dart';

class SecondOnBoardingScreen extends StatelessWidget {
  const SecondOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> _lstAge = [
      "14-17",
      "18-24",
      "25-29",
      "30-34",
      "35-39",
      "39-44",
      "45-49",
      ">= 50",
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              MyProgressBar(notProgressFlex: 1),

              SizedBox(height: 50),

              Text(
                "Select your Age",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFF38B120),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 40,
                    children: _lstAge
                        .map(
                          (ele) => Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              // horizontal: 70,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFFFAE37),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),

                            // color: const Color.fromARGB(255, 129, 176, 214),
                            child: Center(
                              child: Text(ele, style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              Spacer(),
              MyButton(
                text: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalOnBoardingScreen(),
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
