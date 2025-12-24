import 'package:flutter/material.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/screen/dashboard_screen.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_progress_bar.dart';

class FinalOnBoardingScreen extends StatelessWidget {
  const FinalOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> genreList = [
      "Romance",
      "Fantasy",
      "Sci-Fi",
      "Horror",
      "Mystery",
      "Thriller",
      "Psychology",
      "Inspirational",
      "Comedy",
      "Action",
      "Adventure",
      "Comics",
      "Children's",
      "Art & Photography",
      "Food & Drinks",
      "Biography",
      "Science & Technology",
      "Guide/ How-to",
      "Travel",
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        MyProgressBar(notProgressFlex: 0),
                        SizedBox(height: 50),
                        Text(
                          "Choose The Book Genre You Like",
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF38B120),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 30),
                        Wrap(
                          spacing: 13,
                          runSpacing: 20,
                          children: genreList
                              .map(
                                (ele) => Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
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
                                  child: Text(
                                    ele,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        Spacer(),

                        MyButton(
                          text: "Continue",
                          onPressed: () {
                            showMySnackBar(
                              context: context,
                              message: "Successfully created new account",
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
