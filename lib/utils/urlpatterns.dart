import 'package:flutter/material.dart';
import 'package:yinzo/screens/Resetpassword.screen.dart';
import 'package:yinzo/screens/budget_history_screen.dart';
import 'package:yinzo/screens/discussions.screen.dart';
import 'package:yinzo/screens/forgotpassword.screen.dart';
import 'package:yinzo/screens/main_screen.dart';
import 'package:yinzo/screens/login_screen.dart';
import 'package:yinzo/screens/openstreetmapscreen/localisation_map.screen.dart';
import 'package:yinzo/screens/scheduled_visit_screen.dart';
import 'package:yinzo/screens/settings_screen.dart';
import 'package:yinzo/screens/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (_) => MainScreen(),
  '/map': (_) => LocationMapScreen(),
  '/signup': (_) => SignupScreen(),
  'reset-password': (_) => ResetPasswordScreen(),
  '/login': (_) => LoginScreen(),
  '/forgot-password': (_) => ForgotPasswordScreen(),
  '/discussions': (_) => DiscussionsScreen(),
  '/budget-history': (_) => BudgetHistoryScreen(),
  '/settings': (_) => SettingsScreen(),
  '/schedule/appointment': (_) => ScheduledVisitScreen(),
};
