import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

class CartCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback? onAddToCart;
  final VoidCallback? onDelete;

  const CartCard({
    super.key,
    required this.book,
    this.onAddToCart,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/book-cover.jpg",
                height: 90,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
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
                  const SizedBox(height: 6),
                  const Text(
                    "Rs 100",
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: onAddToCart,
                  tooltip: "Add to Cart",
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: "Remove",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
