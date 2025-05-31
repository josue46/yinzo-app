import 'package:flutter/material.dart';
import 'package:yinzo/Budgets/Model/budget_history.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Providers/category_provider.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';
import 'package:yinzo/Users/Provider/user_logement_provider.dart';
import 'package:yinzo/Utils/urlpatterns.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BudgetHistory.initDatabase();

  // Initialisation de l'authentification
  // et ajout de l'intercepteur pour le rafraîchissement du token
  final authProvider = AuthProvider();
  await authProvider.initialize();

  final dio = DioService.getDioInstanceWithBaseUrl();
  dio.interceptors.add(TokenRefreshInterceptor(authProvider));

  initializeDateFormatting(
    'fr_FR',
  ).then((_) => runApp(YinzoApp(authProvider: authProvider)));
}

class YinzoApp extends StatelessWidget {
  final AuthProvider authProvider;
  const YinzoApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LogementProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => UserLogementProvider()),
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
