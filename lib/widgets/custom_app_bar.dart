import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  String title;
  bool? centerTitle;
  TextStyle? style = TextStyle(fontSize: 22);

  CustomAppBar({super.key, required this.title, this.centerTitle, this.style});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: centerTitle,
      title: Text(title, style: style),
      titlePadding: EdgeInsets.symmetric(horizontal: 55, vertical: 10),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
