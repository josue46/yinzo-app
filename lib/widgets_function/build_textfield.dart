import 'package:flutter/material.dart';

Widget buildTextField(
  TextEditingController controller,
  String hint,
  IconData icon, {
  bool isObscure = false,
  TextInputType inputType = TextInputType.text,
  String? Function(String?)? validator,
  Widget? suffixIcon,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isObscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hoverColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black26, width: 1),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          validator ??
          (value) =>
              value == null || value.isEmpty ? 'Ce champ est requis' : null,
    ),
  );
}
