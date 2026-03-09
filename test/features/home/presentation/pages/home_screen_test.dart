import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';

import 'package:vedaverse/features/home/presentation/pages/home_screen.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/genre/presentation/view_model/genre_view_model.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';

///  MOCK VIEW_MODELS

class MockBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(status: BookStatus.initial);

  @override
  Future<void> getAllBooks() async {}
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
    books: List.generate(
      12,
      (index) => BookEntity(
        bookId: 'b$index',
        title: 'Book $index',
        author: 'Author $index',
        price: 1000,
        coverImg: '',
      ),
    ),
  );

  @override
  Future<void> getAllBooks() async {}
}

class ErrorBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(
    status: BookStatus.error,
    errorMessage: "Error loading books",
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

//  TEST MAIN

void main() {
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'token': 'fake-token',
      'userId': '1',
    });

    prefs = await SharedPreferences.getInstance();
  });

  Widget buildWidget({
    required BookViewModel bookNotifier,
    required GenreViewModel genreNotifier,
  }) {
    return ProviderScope(
      overrides: [
        bookViewModelProvider.overrideWith(() => bookNotifier),
        genreViewModelProvider.overrideWith(() => genreNotifier),

        sharedPreferenceProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen - Genre Section', () {
    testWidgets('shows loading spinner when genre loading', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: MockBookViewModel(),
          genreNotifier: LoadingGenreViewModel(),
        ),
      );

      expect(find.byType(CircularProgressIndicator).first, findsOneWidget);
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

  group('HomeScreen - Book Section', () {
    testWidgets('shows loading spinner when books loading', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: LoadingBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      expect(find.byType(CircularProgressIndicator).last, findsOneWidget);
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

    testWidgets('shows books when loaded', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: LoadedBookViewModel(),
          genreNotifier: MockGenreViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('Book 0'), findsOneWidget);
      expect(find.text('Book 7'), findsOneWidget);
    });
  });

  group('HomeScreen - Navigation', () {
    testWidgets('navigates to explore on arrow tap', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          bookNotifier: LoadedBookViewModel(),
          genreNotifier: LoadedGenreViewModel(),
        ),
      );

      await tester.pump();

      await tester.ensureVisible(find.byIcon(Icons.arrow_forward_ios).first);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios).first);
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsNothing);
    });
  });
}
