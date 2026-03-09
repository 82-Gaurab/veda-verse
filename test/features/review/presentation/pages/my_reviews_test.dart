import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vedaverse/features/review/presentation/pages/my_reviews.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

// Fake ViewModel
class FakeReviewViewModel extends ReviewViewModel {
  final ReviewState _state;
  bool getMyReviewsCalled = false;

  FakeReviewViewModel(this._state);

  @override
  ReviewState build() => _state;

  @override
  Future<void> getMyReviews() async {
    getMyReviewsCalled = true;
  }
}

// Fake Data
List<ReviewEntity> fakeReviews() {
  return [
    ReviewEntity(
      reviewId: "r1",
      bookId: "b1",
      rating: 5,
      comment: "Great book!",
      createdAt: DateTime.now(),
      title: 'Great Book!',
    ),
  ];
}

// Helper Widget
Widget buildWidget(ReviewViewModel notifier) {
  return ProviderScope(
    overrides: [reviewViewModelProvider.overrideWith(() => notifier)],
    child: const MaterialApp(home: MyReviews()),
  );
}

void main() {
  group("MyReviews Screen", () {
    // Loading Test

    testWidgets("shows loading spinner when loading", (tester) async {
      final fakeVM = FakeReviewViewModel(
        const ReviewState(status: ReviewStatus.loading),
      );

      await tester.pumpWidget(buildWidget(fakeVM));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Empty Test

    testWidgets("shows empty text when no reviews", (tester) async {
      final fakeVM = FakeReviewViewModel(
        const ReviewState(status: ReviewStatus.loaded, myReviews: []),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      expect(find.text("No Review found"), findsOneWidget);
    });

    // Loaded Test

    testWidgets("shows reviews when loaded", (tester) async {
      final fakeVM = FakeReviewViewModel(
        ReviewState(status: ReviewStatus.loaded, myReviews: fakeReviews()),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Great book!"), findsOneWidget);
    });

    // Back Button Test

    testWidgets("back button pops screen", (tester) async {
      final fakeVM = FakeReviewViewModel(
        const ReviewState(status: ReviewStatus.loaded, myReviews: []),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    // initState Calls getMyReviews

    testWidgets("calls getMyReviews on initState", (tester) async {
      final fakeVM = FakeReviewViewModel(
        const ReviewState(status: ReviewStatus.loading),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      expect(fakeVM.getMyReviewsCalled, true);
    });
  });
}
