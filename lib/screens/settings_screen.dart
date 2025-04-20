import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart' as ip;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres", style: TextStyle(fontSize: 25)),
        backgroundColor: Color(0xFFf5f5f5),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, "/profile"),
                leading: Icon(
                  size: 38,
                  Icons.account_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text("Mon profile"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  ip.Iconsax.heart_bold,
                  color: Colors.redAccent,
                  size: 38,
                ),
                title: const Text("Mes Favoris"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  size: 35,
                  ip.MingCute.book_4_fill,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text("À propos"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  size: 35,
                  ip.Clarity.help_line,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text("Aide"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
