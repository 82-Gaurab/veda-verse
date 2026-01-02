import 'package:flutter/material.dart';

class MyBookCard extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final double price;

  const MyBookCard({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(image, height: 250),
            ),

            SizedBox(height: 8),

            Text(title, style: Theme.of(context).textTheme.bodyMedium),

            SizedBox(height: 3),

            Text(author, style: TextStyle(fontSize: 20)),
            SizedBox(height: 3),

            Text("$price", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
