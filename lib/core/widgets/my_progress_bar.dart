import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  final int notProgressFlex;

  const MyProgressBar({super.key, required this.notProgressFlex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Icon(Icons.arrow_back, size: 30),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(width: 23),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(height: 20, color: Color(0xFFFFAE37)),
                ),
                Expanded(
                  flex: notProgressFlex,
                  child: Container(height: 20, color: Colors.grey[350]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
