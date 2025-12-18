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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/icons/icon.png", height: 40),

                  Text(
                    "Veda",
                    style: TextStyle(
                      fontFamily: "Namaste",
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.notifications, size: 40),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search for books",
                        fillColor: Color(0xFFe7dbcf),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFe7dbcf)),
                          borderRadius: BorderRadius.circular(55),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {},
                    label: Icon(Icons.search, size: 30),
                  ),
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
