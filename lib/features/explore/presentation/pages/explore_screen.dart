import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/explore/presentation/widgets/book_card.dart';
import 'package:vedaverse/features/explore/presentation/widgets/genre_card.dart';
import 'package:vedaverse/features/explore/presentation/widgets/search_section.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';
import 'package:vedaverse/features/genre/presentation/view_model/genre_view_model.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  Future<void> _handleGenreSelection(String genreId) async {
    ref.read(bookViewModelProvider.notifier).getBooksByGenreId(genreId);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(genreViewModelProvider.notifier).getAllGenres();
      ref.read(bookViewModelProvider.notifier).getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final genreState = ref.watch(genreViewModelProvider);
    final bookState = ref.watch(bookViewModelProvider);
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
              SearchSection(books: bookState.books),

              const SizedBox(height: 24),

              /// Genre
              Row(
                children: [
                  const Text(
                    "Genre",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 40,
                child: genreState.status == GenreStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : genreState.genres.isEmpty
                    ? const Text("No genres found")
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: genreState.genres
                            .map(
                              (genre) => GestureDetector(
                                onTap: () =>
                                    _handleGenreSelection(genre.genreId!),
                                child: GenreCard(title: genre.genreTitle),
                              ),
                            )
                            .toList(),
                      ),
              ),

              const SizedBox(height: 24),

              /// Featured Books
              const Text(
                "Books",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              bookState.status == BookStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : bookState.books.isEmpty
                  ? const Text("No Books found")
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: bookState.books.map((book) {
                              return BookCard(
                                title: book.title,
                                author: book.author,
                                coverImg: book.coverImg,
                                bookId: book.bookId!,
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
