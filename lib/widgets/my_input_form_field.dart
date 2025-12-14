import 'package:flutter/material.dart';

class MyInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? inputType;
  final String labelText;
  final bool? obscureText;
  final String? hintText;
  final Icon? icon;
  const MyInputFormField({
    super.key,
    required this.controller,
    this.inputType,
    required this.labelText,
    this.hintText,
    this.obscureText,
    this.icon,
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
        prefixIcon: icon,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter $labelText";
        }
        return null;
      },
    );
  }
}
