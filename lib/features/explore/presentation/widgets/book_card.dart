import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String image;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/book-cover.jpg",
              height: 180,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            author,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            "Rs 100",
            style: const TextStyle(color: Colors.green, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
