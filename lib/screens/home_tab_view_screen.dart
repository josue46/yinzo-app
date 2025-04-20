import 'package:flutter/material.dart';
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
    AllLogementWidget(),
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
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/budget");
                },
                icon: const Icon(OctIcons.search, size: 25),
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
      ),
    );
  }
}
