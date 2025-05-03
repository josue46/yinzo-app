import 'package:flutter/material.dart';
import 'package:yinzo/screens/search_screen.dart';
import 'package:yinzo/widgets/all_logement.dart';
import 'package:icons_plus/icons_plus.dart' show OctIcons;

class HomeTabViewScreen extends StatelessWidget {
  HomeTabViewScreen({super.key});

  final List<Tab> _categories = [
    Tab(child: const Text("Tous")),
    Tab(child: const Text("Maisons")),
    Tab(child: const Text("Appartements")),
    Tab(child: const Text("Studios")),
  ];

  final List<Widget> _tabViews = [
    const AllLogementWidget(),
    const Center(child: Text("Maisons")),
    const Center(child: Text("Appartements")),
    const Center(child: Text("Studios")),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text('Explore', style: TextStyle(fontSize: 25)),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            tabs: _categories,
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 17),
          ),
        ),
        body: TabBarView(children: _tabViews),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black.withValues(alpha: 0.8),
          tooltip: 'Map',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/map');
          },
          label: Row(
            children: [
              Icon(Icons.map_outlined),
              SizedBox(width: 10),
              const Text("Map", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
