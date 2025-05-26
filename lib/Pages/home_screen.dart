import 'package:flutter/material.dart';
import 'package:yinzo/Logements/Screens/all_logement.dart';
import 'package:icons_plus/icons_plus.dart' show OctIcons;
import 'package:yinzo/Search/Screen/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Yinzo', style: const TextStyle(fontFamily: "Inter")),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => SearchScreen()));
              },
              icon: const Icon(OctIcons.search, size: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/schedule/appointment');
              },
              icon: const Icon(Icons.calendar_today, size: 25),
            ),
          ),
        ],
      ),
      body: SafeArea(child: AllLogementScreen()),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        tooltip: 'Map',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.of(context).pushNamed('/map');
        },
        label: Row(
          children: [
            Icon(Icons.map_outlined),
            SizedBox(width: 10),
            const Text(
              "Map",
              style: TextStyle(fontSize: 18, fontFamily: "Inter"),
            ),
          ],
        ),
      ),
    );
  }
}
