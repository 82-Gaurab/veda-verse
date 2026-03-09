import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/presentation/widgets/my_review_card.dart';
import 'package:intl/intl.dart';

void main() {
  ReviewEntity tReview = ReviewEntity(
    reviewId: 'r1',
    bookId: 'b1',
    bookTitle: 'Flutter for Beginners',
    title: 'Amazing Book',
    comment: 'Really helped me understand Flutter.',
    rating: 4.5,
    username: 'john_doe',
    profilePicture: null,
    createdAt: DateTime.parse('2026-03-05T12:00:00Z'),
  );

  Widget buildWidget({required ReviewEntity review}) {
    return MaterialApp(
      home: Scaffold(body: MyReviewCard(review: review)),
    );
  }

  group('MyReviewCard Widget', () {
    testWidgets('renders book title', (tester) async {
      await tester.pumpWidget(buildWidget(review: tReview));
      expect(find.text('Flutter for Beginners'), findsOneWidget);
    });

    testWidgets('renders review title and comment', (tester) async {
      await tester.pumpWidget(buildWidget(review: tReview));
      expect(find.text('Amazing Book'), findsOneWidget);
      expect(find.text('Really helped me understand Flutter.'), findsOneWidget);
    });

    testWidgets('renders formatted created date', (tester) async {
      await tester.pumpWidget(buildWidget(review: tReview));
      final formattedDate = DateFormat(
        'dd MMM yyyy',
      ).format(tReview.createdAt!);
      expect(find.text(formattedDate), findsOneWidget);
    });

    testWidgets('renders rating stars with correct color', (tester) async {
      await tester.pumpWidget(buildWidget(review: tReview));

      // Find all Icon widgets
      final allIcons = find.byType(Icon);

      // Filter by color
      final starIcons = allIcons.evaluate().where((element) {
        final icon = element.widget as Icon;
        return icon.color == AppColors.accent2;
      }).toList();

      expect(
        starIcons.length,
        greaterThanOrEqualTo(1),
      ); // at least 1 star with correct color
    });
  });
}
