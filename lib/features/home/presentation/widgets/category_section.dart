import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.menu_book, "title": "All"},
      {"icon": Icons.tablet_mac, "title": "eBooks"},
      {"icon": Icons.new_releases, "title": "New"},
      {"icon": Icons.auto_stories, "title": "Fiction"},
      {"icon": Icons.psychology, "title": "Self Dev"},
    ];

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: const Color(0xffE8505B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item["title"] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
