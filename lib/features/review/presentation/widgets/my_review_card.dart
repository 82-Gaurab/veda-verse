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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookTitle = review.bookTitle;
    final rating = (review.rating as num).toDouble();
    final createdAt = DateTime.parse("${review.createdAt}");

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
            bookTitle ?? '',
            style: TextStyle(
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
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),

          Divider(
            height: 20,
            color: isDark ? Colors.white24 : Colors.grey[300],
          ),

          /// Review Title
          Text(
            review.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 6),

          /// Review Comment
          Text(
            review.comment,
            style: TextStyle(
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
