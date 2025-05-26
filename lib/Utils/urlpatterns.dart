import 'package:flutter/material.dart';
import 'package:yinzo/Budgets/Screens/budget_history_screen.dart';
import 'package:yinzo/Pages/main_screen.dart';
import 'package:yinzo/Pages/settings_screen.dart';
import 'package:yinzo/Users/Screens/login_screen.dart';
import 'package:yinzo/Users/Screens/signup_screen.dart';
// import 'package:yinzo/openstreetmapscreen/localisation_map.screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (_) => MainScreen(),
  // '/map': (_) => LocationMapScreen(),
  '/signup': (_) => SignupScreen(),
  '/login': (_) => LoginScreen(),
  '/budget-history': (_) => BudgetHistoryScreen(),
  '/settings': (_) => SettingsScreen(),
  // '/forgot-password': (_) => ForgotPasswordScreen(),
  // 'reset-password': (_) => ResetPasswordScreen(),
  // '/schedule/appointment': (_) => ScheduledVisitScreen(),
};
