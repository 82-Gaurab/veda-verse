import 'package:flutter/material.dart';
import 'package:vedaverse/screen/bottom_screen/home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [const HomeScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Wishlist"),
        ],

        backgroundColor: Colors.amber.shade400,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,

        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: lstBottomScreen[_selectedIndex],
    );
  }
}
