import 'package:flutter/material.dart';
import 'package:yinzo/screens/budget_screen.dart';
import 'package:yinzo/screens/conversations_screen.dart';
import 'package:yinzo/screens/home_tab_view_screen.dart';
import 'package:yinzo/screens/scheduled_visit_screen.dart';
import 'package:icons_plus/icons_plus.dart' as ip;
import 'package:yinzo/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeTabViewScreen(),
    const ConversationsScreen(),
    const BudgetScreen(),
    ScheduledVisitScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            tooltip: "Découvrir des logements en location",
            icon: Icon(Icons.explore_outlined),
            label: "Explorer",
          ),
          BottomNavigationBarItem(
            tooltip: "Voir les discussions",
            icon: Icon(ip.EvaIcons.message_circle_outline),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            tooltip: "Voir et calculer votre budget",
            icon: Icon(ip.Clarity.wallet_line),
            label: "Mon budget",
          ),
          BottomNavigationBarItem(
            tooltip: "Rendez-vous",
            icon: Icon(Icons.calendar_today),
            label: "RDV",
          ),
          BottomNavigationBarItem(
            tooltip: "Paramètres",
            icon: Icon(ip.Clarity.settings_line),
            label: "Paramètres",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
