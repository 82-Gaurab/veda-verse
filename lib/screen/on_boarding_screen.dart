import 'package:flutter/material.dart';
import 'package:vedaverse/widgets/my_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> genreList = [
      "Genre",
      "Genre",
      "Longer Genre",
      "Genre 21123123",
      "Genre",
      "Longest Genre till date",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
      "Genre",
    ];

    return Scaffold(
      appBar: AppBar(title: Text("On Boarding 1"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(13),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20,
            runSpacing: 30,
            children: genreList
                .map(
                  (ele) => Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),

                    color: const Color.fromARGB(255, 129, 176, 214),
                    child: Text(ele),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
