import 'package:flutter/material.dart';

import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class CartCard extends StatelessWidget {
  final CartEntity book;
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

            const SizedBox(width: 8),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Remove",
            ),
          ],
        ),
      ),
    );
  }
}
