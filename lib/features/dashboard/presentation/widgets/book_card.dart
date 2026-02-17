import 'package:flutter/material.dart';

class ModernBookCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;

  const ModernBookCard({
    super.key,
    required this.image,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(image, fit: BoxFit.cover),
                ),
              ),

              // Bookmark Ribbon
              Positioned(
                bottom: -5,
                right: 20,
                child: Container(
                  width: 25,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xffE8B04A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            author,
            style: const TextStyle(color: Color(0xffE8505B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
