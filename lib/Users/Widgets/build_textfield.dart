import 'package:flutter/material.dart';

class BuildTextfield extends StatelessWidget {
  const BuildTextfield({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isObscure = false,
    this.inputType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isObscure;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
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
}
