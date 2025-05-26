import 'package:flutter/material.dart';

class MyCustomForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final String? Function(String?) validator;
  final String? hintText;

  const MyCustomForm({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.autofocus,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus ?? false,
      keyboardType: keyboardType ?? TextInputType.name,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: label,
      ),
      validator: validator,
    );
  }
}
