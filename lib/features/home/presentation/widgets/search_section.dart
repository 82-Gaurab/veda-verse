import 'package:flutter/material.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    // pull the data from backend
    List<BookEntity> books = [
      BookEntity(title: "somthing", author: "salkf", rating: 2.0),
      BookEntity(title: "asdf", author: "salkf", rating: 2.0),
      BookEntity(title: "zzxzx", author: "salkf", rating: 2.0),
      BookEntity(title: "llp", author: "salkf", rating: 2.0),
      BookEntity(title: "kj", author: "salkf", rating: 2.0),
      BookEntity(title: "q", author: "salkf", rating: 2.0),
      BookEntity(title: "eqq", author: "salkf", rating: 2.0),
    ];
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

                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => RecipePage(recipe: filteredItem),
                    //   ),
                    // );
                  },
                ),
              );
            });
      },
    );
  }
}
