import 'package:flutter/material.dart';
import 'package:vedaverse/features/explore/presentation/widgets/book_card.dart';
import 'package:vedaverse/features/home/presentation/widgets/search_section.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Explore Books",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Search Bar
              SearchSection(),

              const SizedBox(height: 24),

              /// Genre
              Row(
                children: [
                  const Text(
                    "Genre",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip("Fiction"),
                    _buildCategoryChip("Science"),
                    _buildCategoryChip("Business"),
                    _buildCategoryChip("Romance"),
                    _buildCategoryChip("History"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Featured Books
              const Text(
                "Top Charts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    BookCard(
                      title: "The Silent Patient",
                      author: "Alex Michaelides",
                      image: "https://via.placeholder.com/120x180",
                    ),
                    BookCard(
                      title: "Atomic Habits",
                      author: "James Clear",
                      image: "https://via.placeholder.com/120x180",
                    ),
                    BookCard(
                      title: "1984",
                      author: "George Orwell",
                      image: "https://via.placeholder.com/120x180",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Popular Books
              const Text(
                "Top Selling",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Column(
                children: const [
                  PopularBookTile(
                    title: "The Alchemist",
                    author: "Paulo Coelho",
                    image: "https://via.placeholder.com/60x90",
                  ),
                  PopularBookTile(
                    title: "Rich Dad Poor Dad",
                    author: "Robert Kiyosaki",
                    image: "https://via.placeholder.com/60x90",
                  ),
                  PopularBookTile(
                    title: "Rich Dad Poor Dad",
                    author: "Robert Kiyosaki",
                    image: "https://via.placeholder.com/60x90",
                  ),
                  PopularBookTile(
                    title: "Rich Dad Poor Dad",
                    author: "Robert Kiyosaki",
                    image: "https://via.placeholder.com/60x90",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCategoryChip(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(title),
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        labelStyle: const TextStyle(color: Colors.green),
      ),
    );
  }
}

/// Horizontal Book Card

/// Vertical Popular Book Tile
class PopularBookTile extends StatelessWidget {
  final String title;
  final String author;
  final String image;

  const PopularBookTile({
    super.key,
    required this.title,
    required this.author,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            "assets/images/book-cover.jpg",
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(title),
        subtitle: Text(author, style: TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
