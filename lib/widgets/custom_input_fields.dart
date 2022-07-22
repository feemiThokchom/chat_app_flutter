import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String redEx;
  final String hintText;
  final String obscureText;

  const CustomTextFormField({
    Key? key,
    required this.onSaved,
    required this.redEx,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
    );
  }
}
