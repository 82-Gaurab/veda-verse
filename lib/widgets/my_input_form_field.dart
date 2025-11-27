import 'package:flutter/material.dart';

class MyInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? inputType;
  final String labelText;
  final bool? obscureText;
  final String? hintText;
  const MyInputFormField({
    super.key,
    required this.controller,
    this.inputType,
    required this.labelText,
    this.hintText,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFAE37)),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFAE37), width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter value";
        }
        return null;
      },
    );
  }
}
