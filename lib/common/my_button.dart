import 'package:flutter/material.dart';

showMyButton({
  required String text,
  Color? color,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,

    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Color(0xFFFFAE37),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
    ),
  );
}
