import 'package:flutter/material.dart';
import 'package:yinzo/core/providers/logement_provider.dart';
import 'package:yinzo/models/budget_history.dart';
import 'package:yinzo/utils/urlpatterns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BudgetHistory.initDatabase();
  initializeDateFormatting('fr_FR').then((_) => runApp(YinzoApp()));
}

class YinzoApp extends StatelessWidget {
  const YinzoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LogementProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        title: 'Yinzo',
        theme: ThemeData(
          primaryColor: Color(0xFF2ECC71), // Vert Émeraude
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2ECC71), // Couleur primaire
            secondary: Color(0xFF48C9B0), // Vert Menthe
          ),
          cardColor: Color(0xFFFFFFFF),
          scaffoldBackgroundColor: Color(0xFFF5F5F5), // Fond blanc cassé
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
      ),
    );
  }
}
