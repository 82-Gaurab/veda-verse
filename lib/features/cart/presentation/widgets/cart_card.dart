import 'package:flutter/material.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class CartCard extends StatelessWidget {
  final CartEntity book;

  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartCard({
    super.key,
    required this.book,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final String fullUrl = "${ApiEndpoints.baseUrl}${book.coverImg}";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fullUrl,
                width: 100,
                height: 150,
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;

                  if (frame == null) {
                    return const SizedBox(
                      width: 100,
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryLight,
                        ),
                      ),
                    );
                  }

                  return child;
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/default-book-cover.png",
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title!,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    book.author!,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Rs ${book.price}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: book.quantity == 1 ? null : onDecrease,
                      ),

                      Text(
                        "${book.quantity}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: onIncrease,
                      ),

                      const Spacer(),

                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: onRemove,
                      ),
                    ],
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
