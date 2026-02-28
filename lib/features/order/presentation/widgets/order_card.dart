import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vedaverse/app/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final List<Map<String, dynamic>> books;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.books,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${orderId.substring(0, 6)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Placed on ${DateFormat('dd MMM yyyy').format(createdAt)}",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),

          const Divider(height: 20),

          /// Books
          Column(
            children: books.map((book) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${book["title"]}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text("x${book["quantity"]}"),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(height: 20),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Rs. ${totalPrice.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
