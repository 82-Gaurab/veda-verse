import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  final String title;

  const GenreCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(label: Text(title)),
    );
  }
}
