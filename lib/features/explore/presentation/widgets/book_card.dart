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
    final theme = Theme.of(context);
    final String fullUrl = "${ApiEndpoints.baseUrl}$coverImg";
    final media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, BookDetail(bookId: bookId));
      },
      child: Container(
        width: media.width * 0.25,
        padding: const EdgeInsets.only(bottom: 6),
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: theme.brightness == Brightness.dark
              ? AppColors.darkSoftShadow
              : AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fullUrl,
                width: media.width * 0.22,
                height: media.width * 0.30,
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
                  return Image.asset(
                    "assets/images/default-book-cover.png",
                    width: media.width * 0.22,
                    height: media.width * 0.30,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    author,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rs 100",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
