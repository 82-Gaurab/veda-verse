import 'package:flutter/material.dart';
import 'package:vedaverse/features/dashboard/presentation/widgets/book_card.dart';
import 'package:vedaverse/features/dashboard/presentation/widgets/section_header.dart';

class BookSection extends StatelessWidget {
  final String title;

  const BookSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              ModernBookCard(
                image:
                    "https://images-na.ssl-images-amazon.com/images/I/91SZSW8qSsL.jpg",
                title: "Thorn and Roses",
                author: "Sarah J. Maas",
              ),

              ModernBookCard(image: "", title: "", author: ""),

              ModernBookCard(
                image:
                    "https://images-na.ssl-images-amazon.com/images/I/81XQw5QwQ0L.jpg",
                title: "Mist and Fury",
                author: "Sarah J. Maas",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
