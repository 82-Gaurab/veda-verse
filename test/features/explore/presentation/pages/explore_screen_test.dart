import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vedaverse/features/explore/presentation/pages/explore_screen.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/presentation/view_model/genre_view_model.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';

// MOCK View Model

class MockBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(status: BookStatus.initial);

  @override
  Future<void> getAllBooks() async {}

  @override
  Future<void> getBooksByGenreId(String genreId) async {}
}

class LoadingBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(status: BookStatus.loading);

  @override
  Future<void> getAllBooks() async {}
}

class LoadedBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => BookState(
    status: BookStatus.loaded,
    books: [
      BookEntity(
        bookId: 'b1',
        title: 'Atomic Habits',
        author: 'James Clear',
        price: 1200,
        coverImg: '',
      ),
    ],
  );

  @override
  Future<void> getAllBooks() async {}
}

class MockGenreViewModel extends GenreViewModel with Mock {
  @override
  GenreState build() => const GenreState(status: GenreStatus.initial);

  @override
  Future<void> getAllGenres() async {}
}

class LoadingGenreViewModel extends GenreViewModel with Mock {
  @override
  GenreState build() => const GenreState(status: GenreStatus.loading);

  @override
  Future<void> getAllGenres() async {}
}

class LoadedGenreViewModel extends GenreViewModel with Mock {
  @override
  GenreState build() => GenreState(
    status: GenreStatus.loaded,
    genres: [GenreEntity(genreId: 'g1', genreTitle: 'Self Help')],
  );

  @override
  Future<void> getAllGenres() async {}
}

// HELPER

Widget buildWidget({
  required BookViewModel bookNotifier,
  required GenreViewModel genreNotifier,
}) {
  return ProviderScope(
    overrides: [
      bookViewModelProvider.overrideWith(() => bookNotifier),
      genreViewModelProvider.overrideWith(() => genreNotifier),
    ],
    child: const MaterialApp(home: ExploreScreen()),
  );
}

void main() {
  group('genre section', () {
    testWidgets('shows loading spinner when genre loading', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: MockBookViewModel(),
          genreNotifier: LoadingGenreViewModel(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no genres found when empty', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: MockBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('No genres found'), findsOneWidget);
    });

    testWidgets('shows genre when loaded', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: MockBookViewModel(),
          genreNotifier: LoadedGenreViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('Self Help'), findsOneWidget);
    });
  });

  group('book section', () {
    testWidgets('shows loading spinner when books loading', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: LoadingBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no books found when empty', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: MockBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('No Books found'), findsOneWidget);
    });

    testWidgets('shows book card when loaded', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: LoadedBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('Atomic Habits'), findsOneWidget);
      expect(find.text('James Clear'), findsOneWidget);
    });
  });
}
