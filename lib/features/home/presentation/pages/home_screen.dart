import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/explore/presentation/widgets/book_card.dart';
import 'package:vedaverse/features/explore/presentation/widgets/genre_card.dart';
import 'package:vedaverse/features/home/presentation/widgets/header_section.dart';
import 'package:vedaverse/features/home/presentation/widgets/top_pick_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<BookEntity> topPickBooks = [
      BookEntity(title: "somthing", author: "salkf", rating: 2.0),
      BookEntity(title: "asdf", author: "salkf", rating: 2.0),
      BookEntity(title: "zzxzx", author: "salkf", rating: 2.0),
      BookEntity(title: "llp", author: "salkf", rating: 2.0),
      BookEntity(title: "kj", author: "salkf", rating: 2.0),
      BookEntity(title: "q", author: "salkf", rating: 2.0),
      BookEntity(title: "eqq", author: "salkf", rating: 2.0),
    ];
    List<BookEntity> bestSellerBooks = [
      BookEntity(title: "somthing", author: "salkf", rating: 2.0),
      BookEntity(title: "asdf", author: "salkf", rating: 2.0),
      BookEntity(title: "zzxzx", author: "salkf", rating: 2.0),
      BookEntity(title: "llp", author: "salkf", rating: 2.0),
      BookEntity(title: "kj", author: "salkf", rating: 2.0),
      BookEntity(title: "q", author: "salkf", rating: 2.0),
      BookEntity(title: "eqq", author: "salkf", rating: 2.0),
    ];

    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF6EFE7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                child: Transform.scale(
                  scale: 1.5,
                  origin: Offset(0, media.width * 0.8),
                  child: Container(
                    width: media.width,
                    height: media.width,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(media.width * 0.5),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderSection(),
                  SizedBox(height: media.width * 0.13),
                  Row(
                    children: const [
                      Text(
                        "Our Top Picks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  SizedBox(
                    width: media.width,
                    height: media.width * 0.8,
                    child: CarouselSlider.builder(
                      itemCount: topPickBooks.length,
                      itemBuilder:
                          (
                            BuildContext context,
                            int itemIndex,
                            int pageViewIndex,
                          ) {
                            var book = topPickBooks[itemIndex];
                            return TopPicksSection(book: book);
                          },
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                        viewportFraction: 0.45,
                        enlargeFactor: 0.5,
                        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Bestsellers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: bestSellerBooks.map((book) {
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: BookCard(
                            title: book.title,
                            author: book.author,
                            image: book.title,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      const Text(
                        "Genre",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        GenreCard(title: "Fiction"),
                        GenreCard(title: "Science"),
                        GenreCard(title: "Business"),
                        GenreCard(title: "Romance"),
                        GenreCard(title: "History"),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Recently Added",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
