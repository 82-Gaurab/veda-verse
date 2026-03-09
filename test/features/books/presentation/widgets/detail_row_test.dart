import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/features/books/presentation/widgets/detail_row.dart';

void main() {
  Widget buildWidget({
    required String title,
    required String value,
    Color? textColor,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: DetailRow(title: title, value: value, textColor: textColor),
      ),
    );
  }

  group('DetailRow Widget', () {
    testWidgets('renders title and value', (tester) async {
      await tester.pumpWidget(buildWidget(title: 'Author', value: 'John Doe'));

      expect(find.text('Author'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('uses default text color when textColor is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(title: 'Genre', value: 'Fiction'));

      final titleText = tester.widget<Text>(find.text('Genre'));
      final valueText = tester.widget<Text>(find.text('Fiction'));

      expect(titleText.style?.color, Colors.black);
      expect(valueText.style?.color, Colors.black);
    });

    testWidgets('applies custom textColor when provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(title: 'Price', value: 'NRs.500', textColor: Colors.red),
      );

      final titleText = tester.widget<Text>(find.text('Price'));
      final valueText = tester.widget<Text>(find.text('NRs.500'));

      expect(titleText.style?.color, Colors.red);
      expect(valueText.style?.color, Colors.red);
    });
  });
}
