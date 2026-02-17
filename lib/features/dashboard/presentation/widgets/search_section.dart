import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for books",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffE8505B),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
