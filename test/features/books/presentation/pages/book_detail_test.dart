import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/features/books/presentation/pages/book_detail.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';

/// MOCK VIEWMODELS

class MockBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(status: BookStatus.initial);

  @override
  Future<void> getBookById(String id) async {}
}

class LoadingBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(status: BookStatus.loading);

  @override
  Future<void> getBookById(String id) async {}
}

class ErrorBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => const BookState(
    status: BookStatus.error,
    errorMessage: 'Failed to load book',
  );

  @override
  Future<void> getBookById(String id) async {}
}

class LoadedBookViewModel extends BookViewModel with Mock {
  @override
  BookState build() => BookState(
    status: BookStatus.loaded,
    book: BookEntity(
      bookId: 'b1',
      title: 'Atomic Habits',
      author: 'James Clear',
      price: 1200,
      genre: ['Self Help'],
      publishedYear: '2018',
      description: 'A practical guide to building good habits.',
      coverImg: null,
    ),
  );

  @override
  Future<void> getBookById(String id) async {}
}

class MockReviewViewModel extends ReviewViewModel with Mock {
  @override
  ReviewState build() => const ReviewState(bookReviews: []);

  @override
  Future<void> getBookReview({required String bookId}) async {}
}

class MockCartViewModel extends CartViewModel with Mock {
  @override
  CartState build() => const CartState();
}

/// HELPER

Widget buildWidget({required BookViewModel notifier}) {
  return ProviderScope(
    overrides: [
      bookViewModelProvider.overrideWith(() => notifier),
      reviewViewModelProvider.overrideWith(() => MockReviewViewModel()),
      cartViewModelProvider.overrideWith(() => MockCartViewModel()),
    ],
    child: const MaterialApp(home: BookDetail(bookId: 'b1')),
  );
}

void main() {
  group('loading state', () {
    testWidgets('shows spinner when loading', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadingBookViewModel()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('empty state', () {
    testWidgets('shows spinner when no book selected', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: MockBookViewModel()));

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('loaded state', () {
    testWidgets('shows Add to Cart button when loaded', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadedBookViewModel()));

      await tester.pump();

      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('shows book title when loaded', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadedBookViewModel()));

      await tester.pump();

      expect(find.text('Atomic Habits'), findsOneWidget);
    });

    testWidgets('shows author name when loaded', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadedBookViewModel()));

      await tester.pump();

      expect(find.text('by James Clear'), findsOneWidget);
    });

    testWidgets('shows genre when loaded', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadedBookViewModel()));

      await tester.pump();

      expect(find.text('Self Help'), findsOneWidget);
    });
  });
}
