import 'package:flutter/material.dart';
import 'package:yinzo/utils/urlpatterns.dart';

void main() {
  runApp(YinzoApp());
}

class YinzoApp extends StatelessWidget {
  const YinzoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      title: 'Yinzo',
      theme: ThemeData(
        primaryColor: Color(0xFF2ECC71), // Vert Émeraude
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2ECC71), // Couleur primaire
          secondary: Color(0xFF48C9B0), // Vert Menthe
        ),
        scaffoldBackgroundColor: Color(0xFFF8F9FA), // Fond blanc cassé
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA6E22E), // Vert Citron pour boutons
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
