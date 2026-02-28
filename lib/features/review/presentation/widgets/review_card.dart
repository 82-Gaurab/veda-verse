import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vedaverse/app/theme/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final dynamic review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final profileUrl =
        "http://192.168.100.8:4000/api/v1${review.profilePicture}";

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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Row
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  profileUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }

                        if (frame == null) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryLight,
                            ),
                          );
                        }

                        return child;
                      },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.username ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  /// ⭐ Rating
                  IgnorePointer(
                    ignoring: true,
                    child: RatingBar.builder(
                      initialRating: review.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: AppColors.accent2),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review Title
          Text(
            review.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Review Comment
          Text(
            review.comment,
            style: const TextStyle(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
