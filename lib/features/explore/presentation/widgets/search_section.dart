import 'package:flutter/material.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/presentation/pages/book_detail.dart';

class SearchSection extends StatelessWidget {
  final List<BookEntity> books;
  const SearchSection({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: controller,
                  hintText: "Search for books",
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  elevation: WidgetStatePropertyAll(0),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                ),
              ),

              /// Your gradient search button
              GestureDetector(
                onTap: () {
                  controller.openView();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.5,
                      colors: [
                        Colors.greenAccent.shade400,
                        Colors.green.shade700,
                      ],
                    ),
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },

      suggestionsBuilder: (BuildContext context, SearchController controller) {
        String userInput = controller.text.toLowerCase();

        return books
            .where((book) => book.title.toLowerCase().contains(userInput))
            .map((filteredItem) {
              return Container(
                color: Colors.grey.shade200,
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                child: ListTile(
                  title: Text(filteredItem.title),
                  onTap: () {
                    controller.closeView(filteredItem.title);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetail(bookId: filteredItem.bookId!),
                      ),
                    );
                  },
                ),
              );
            });
      },
    );
  }
}
