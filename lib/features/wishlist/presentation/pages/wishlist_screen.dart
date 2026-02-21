import 'package:flutter/material.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/wishlist/presentation/widgets/wishlist_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<BookEntity> whishListBooks = [
    BookEntity(
      title: "somthingasdfadsfadsfadsfasdfasdf",
      author: "salkf",
      rating: 2.0,
    ),
    BookEntity(title: "asdf", author: "salkf", rating: 2.0),
    BookEntity(title: "zzxzx", author: "salkf", rating: 2.0),
    BookEntity(title: "llp", author: "salkf", rating: 2.0),
    BookEntity(title: "kj", author: "salkf", rating: 2.0),
    BookEntity(title: "q", author: "salkf", rating: 2.0),
    BookEntity(title: "eqq", author: "salkf", rating: 2.0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: whishListBooks.map((book) {
                return WishlistCard(book: book);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
