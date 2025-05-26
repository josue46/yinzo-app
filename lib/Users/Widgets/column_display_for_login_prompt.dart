import 'package:flutter/material.dart';

class ColumnDisplayForLoginPrompt extends StatelessWidget {
  const ColumnDisplayForLoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Avez-vous un compte ?",
          style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
          child: Text(
            "Se connecter",
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
