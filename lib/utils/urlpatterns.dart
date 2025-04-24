import 'package:flutter/material.dart';
import 'package:yinzo/screens/Resetpassword.screen.dart';
import 'package:yinzo/screens/budget_history_screen.dart';
import 'package:yinzo/screens/discussions.screen.dart';
import 'package:yinzo/screens/forgotpassword.screen.dart';
import 'package:yinzo/screens/home_screen.dart';
import 'package:yinzo/screens/login.screen.dart';
import 'package:yinzo/screens/openstreetmapscreen/localisation_map.screen.dart';
import 'package:yinzo/screens/profile_screen.dart';
import 'package:yinzo/screens/signup.screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (_) => HomeScreen(),
  '/map': (_) => LocationMapScreen(),
  '/sinup': (_) => SignUpScreen(),
  'reset-password': (_) => ResetPasswordScreen(),
  '/login': (_) => SignInScreen(),
  '/forgot-password': (_) => ForgotPasswordScreen(),
  '/discussions': (_) => DiscussionsScreen(),
  '/budget-history': (_) => BudgetHistoryScreen(),
  '/profile': (_) => ProfileScreen(),
};
