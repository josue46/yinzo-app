import 'package:flutter/material.dart';
import 'package:yinzo/Budgets/Screens/budget_screen.dart';
import 'package:yinzo/Chat/Screens/conversations_screen.dart';
import 'package:yinzo/Pages/home_screen.dart';
import 'package:yinzo/Users/Screens/profile_screen.dart';
import 'package:icons_plus/icons_plus.dart' show Iconsax, EvaIcons, Clarity;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ConversationsScreen(),
    const BudgetScreen(),
    const ProfileScreen(),
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
            icon: Icon(Iconsax.home_1_outline),
            activeIcon: Icon(Iconsax.home_bold),
            label: "Acceuil",
          ),
          BottomNavigationBarItem(
            tooltip: "Voir les discussions",
            icon: Icon(EvaIcons.message_circle_outline),
            activeIcon: Icon(EvaIcons.message_circle),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            tooltip: "Voir et calculer votre budget",
            icon: Icon(Clarity.wallet_line),
            activeIcon: Icon(Clarity.wallet_solid),
            label: "Mon budget",
          ),
          BottomNavigationBarItem(
            tooltip: "Mon compte",
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Moi",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
