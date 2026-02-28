import 'package:flutter/material.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/presentation/pages/book_detail.dart';

class TopPicksSection extends StatelessWidget {
  final BookEntity book;

  const TopPicksSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;
    final String fullUrl = "${ApiEndpoints.baseUrl}${book.coverImg}";

    return GestureDetector(
      onTap: () => AppRoutes.push(context, BookDetail(bookId: book.bookId!)),
      child: SizedBox(
        width: media.width * 0.32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: theme.brightness == Brightness.dark
                    ? AppColors.darkSoftShadow
                    : AppColors.softShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fullUrl,
                  width: 130,
                  height: 180,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
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
                      "assets/images/book-cover.jpg",
                      width: media.width * 0.32,
                      height: media.width * 0.50,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              book.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              book.author,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
