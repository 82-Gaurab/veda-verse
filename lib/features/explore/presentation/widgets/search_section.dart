import 'package:flutter/material.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/presentation/pages/book_detail.dart';

class SearchSection extends StatelessWidget {
  final List<BookEntity> books;

  const SearchSection({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: theme.brightness == Brightness.dark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: controller,
                  hintText: "Search for books",
                  backgroundColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  elevation: const WidgetStatePropertyAll(0),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                  onTap: controller.openView,
                  onChanged: (_) => controller.openView(),
                ),
              ),

              GestureDetector(
                onTap: controller.openView,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.5,
                      colors: [Color(0xFF43A047), Color(0xFF388E3C)],
                    ),
                  ),
                  child: Icon(Icons.search, color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        );
      },

      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final theme = Theme.of(context);
        final userInput = controller.text.toLowerCase();

        return books
            .where((book) => book.title.toLowerCase().contains(userInput))
            .map(
              (filteredItem) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    filteredItem.title,
                    style: theme.textTheme.bodyMedium,
                  ),
                  onTap: () {
                    controller.closeView(filteredItem.title);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BookDetail(bookId: filteredItem.bookId!),
                      ),
                    );
                  },
                ),
              ),
            );
      },
    );
  }
}
