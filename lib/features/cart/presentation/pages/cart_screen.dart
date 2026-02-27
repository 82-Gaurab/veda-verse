import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/cart/presentation/widgets/cart_card.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  List<BookEntity> cartBooks = [
    BookEntity(
      title: "somthingasdfadsfadsfadsfasdfasdf",
      author: "salkf",
      price: 2.0,
    ),
    BookEntity(title: "asdf", author: "salkf", price: 2.0),
    BookEntity(title: "zzxzx", author: "salkf", price: 2.0),
    BookEntity(title: "llp", author: "salkf", price: 2.0),
    BookEntity(title: "kj", author: "salkf", price: 2.0),
    BookEntity(title: "q", author: "salkf", price: 2.0),
    BookEntity(title: "eqq", author: "salkf", price: 2.0),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authViewModelProvider.notifier).getMyInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(authState.entity!.firstName)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: cartBooks.map((book) {
                return CartCard(book: book);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
