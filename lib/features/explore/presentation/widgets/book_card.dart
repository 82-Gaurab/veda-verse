import 'package:flutter/material.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/books/presentation/pages/book_detail.dart';

class BookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String author;
  final String? coverImg;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.coverImg,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final String fullUrl = "${ApiEndpoints.baseUrl}$coverImg";
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, BookDetail(bookId: bookId));
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.only(bottom: 3),
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fullUrl,
                width: 130,
                height: 180,
                fit: BoxFit.cover,

                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;

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
                  return Icon(Icons.book, size: 60, color: AppColors.primary);
                },
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
                Text(
                  "Rs 100",
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
