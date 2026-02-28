// detail_row.dart
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? textColor; // <-- add this

  const DetailRow({
    super.key,
    required this.title,
    required this.value,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: textColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
