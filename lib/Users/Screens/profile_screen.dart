import 'package:flutter/material.dart';
import 'package:yinzo/Pages/settings_screen.dart';
import 'package:yinzo/Users/Screens/profile_details_screen.dart';
import 'package:yinzo/Users/Widgets/profile_menu.dart';
import 'package:yinzo/Users/Widgets/profile_picture.dart';
import 'package:yinzo/Utils/svg_pattern.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePicture(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Mon compte",
              icon: profileIconSvg,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Mes Logements",
              icon: profileIconSvg,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Réservations",
              icon: profileIconSvg,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Mes rendez-vous",
              icon: profileIconSvg,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: notificationIconSvg,
              press: () {},
            ),
            ProfileMenu(
              text: "Paramètres",
              icon: settingIconSvg,
              press: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
            ProfileMenu(text: "Centre d'aide", icon: helpIconSvg, press: () {}),
            ProfileMenu(
              text: "Se déconnecter",
              icon: logOutIconSvg,
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
