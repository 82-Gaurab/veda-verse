import 'package:flutter/material.dart';
import 'package:vedaverse/screen/bottom_navigation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigationScreen(),
      // body: SafeArea(
      //   child: Padding(
      //     padding: EdgeInsetsGeometry.all(13),
      //     child: Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           // SizedBox(height: 40),
      //           // Row(
      //           //   crossAxisAlignment: CrossAxisAlignment.center,
      //           //   children: [
      //           //     Image.asset("assets/images/title.png", width: 180),
      //           //     Spacer(),
      //           //     Icon(Icons.search, size: 40),
      //           //     SizedBox(width: 10),
      //           //     Icon(Icons.notifications, size: 40),
      //           //   ],
      //           // ),
      //           Text("Welcome to Home Screen", style: TextStyle(fontSize: 30)),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
