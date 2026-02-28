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
    final theme = Theme.of(context);
    final genreState = ref.watch(genreViewModelProvider);
    final bookState = ref.watch(bookViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Explore Books",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Search
              SearchSection(books: bookState.books),

              const SizedBox(height: 24),

              /// Genre
              Text(
                "Genre",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 40,
                child: genreState.status == GenreStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : genreState.genres.isEmpty
                    ? Text("No genres found", style: theme.textTheme.bodyMedium)
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => ref
                                .read(bookViewModelProvider.notifier)
                                .getAllBooks(),
                            child: const GenreCard(title: "All"),
                          ),
                          const SizedBox(width: 8),
                          ...genreState.genres.map(
                            (genre) => GestureDetector(
                              onTap: () =>
                                  _handleGenreSelection(genre.genreId!),
                              child: GenreCard(title: genre.genreTitle),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),

              /// Books
              Text(
                "Books",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              bookState.status == BookStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : bookState.books.isEmpty
                  ? Text("No Books found", style: theme.textTheme.bodyMedium)
                  : Center(
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
