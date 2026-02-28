import 'package:flutter/material.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';

import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class CartCard extends StatelessWidget {
  final CartEntity book;

  const CartCard({super.key, required this.book});

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
                    width: 130,
                    height: 180,
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
                  const SizedBox(height: 6),
                  Text(
                    "Quantity: ${book.quantity}",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rs ${book.price}",
                    style: TextStyle(color: Colors.green, fontSize: 14),
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
