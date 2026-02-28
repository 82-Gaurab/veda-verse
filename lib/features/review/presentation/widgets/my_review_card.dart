import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

class MyReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const MyReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final bookTitle = review.bookTitle;
    final rating = (review.rating as num).toDouble();
    final createdAt = DateTime.parse("${review.createdAt}");

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Title
          Text(
            bookTitle!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 6),

          // Rating + Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IgnorePointer(
                ignoring: true,
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: AppColors.accent2),
                  onRatingUpdate: (rating) {},
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const Divider(height: 20),

          /// Review Title
          Text(
            review.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),

          const SizedBox(height: 6),

          /// Review Comment
          Text(
            review.comment,
            style: const TextStyle(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
