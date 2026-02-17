// import 'package:flutter/material.dart';

// class ExploreScreen extends StatelessWidget {
//   const ExploreScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Text("Explore Screen", style: TextStyle(fontSize: 30)),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search books, authors...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Categories
              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                "Featured",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
                "Popular",
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
                ],
              ),
            ],
          ),
        ),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  static Widget _buildCategoryChip(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(title),
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        labelStyle: const TextStyle(color: Colors.deepPurple),
      ),
    );
  }
}

/// Horizontal Book Card
class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String image;

  const BookCard({
    Key? key,
    required this.title,
    required this.author,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/book-cover.jpg",
              height: 160,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(author, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

/// Vertical Popular Book Tile
class PopularBookTile extends StatelessWidget {
  final String title;
  final String author;
  final String image;

  const PopularBookTile({
    Key? key,
    required this.title,
    required this.author,
    required this.image,
  }) : super(key: key);

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
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title),
        subtitle: Text(author),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
