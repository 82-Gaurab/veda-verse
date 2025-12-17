import 'package:flutter/material.dart';
import 'package:vedaverse/widgets/my_book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.all(13),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/title.png", width: 180),
                  Spacer(),
                  Icon(Icons.search, size: 40),
                  SizedBox(width: 10),
                  Icon(Icons.notifications, size: 40),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    "Best Selling",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                      ),
                      child: Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBookCard(
                    title: "Harry Potter",
                    author: "J.K Rowling",
                    image: 'assets/images/book-cover.jpg',
                    price: 100,
                  ),
                  MyBookCard(
                    title: "Harry Potter",
                    author: "J.K Rowling",
                    image: 'assets/images/book-cover.jpg',
                    price: 100,
                  ),
                ],
              ),

              SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "Popular",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                      ),
                      child: Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBookCard(
                    title: "Harry Potter",
                    author: "J.K Rowling",
                    image: 'assets/images/book-cover.jpg',
                    price: 100,
                  ),
                  MyBookCard(
                    title: "Harry Potter",
                    author: "J.K Rowling",
                    image: 'assets/images/book-cover.jpg',
                    price: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
