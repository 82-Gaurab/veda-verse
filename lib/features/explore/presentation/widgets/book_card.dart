import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vedaverse/app/theme/app_colors.dart';

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
      padding: const EdgeInsets.only(bottom: 3),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16), // 👈 Rounded corners
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/book-cover.jpg",
              height: 180,
              width: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                author,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              IgnorePointer(
                ignoring: true,
                child: RatingBar.builder(
                  initialRating: 2.5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: AppColors.accent2),
                  onRatingUpdate: (rating) {},
                ),
              ),
              Text(
                "Rs 100",
                style: const TextStyle(color: Colors.green, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
