import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart' show OctIcons;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _resultats = [];
  final List<String> _donneesFictives = [
    "Maison à Gombe",
    "Appartement à Limete",
    "Villa à Mont-Fleury",
    "Studio à Bandalungwa",
    "Agence Kasaï Immo",
    "Yinzo Verified - Ngaliema",
    "Maison avec piscine à Binza",
    "Appartement meublé à Kintambo",
  ];

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _resultats =
            _donneesFictives
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rechercher")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Rechercher une maison, un appartement...",
                prefixIcon: const Icon(OctIcons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _resultats.clear());
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📋 Liste des résultats
            Expanded(
              child:
                  _resultats.isEmpty
                      ? const Center(child: Text("Aucun résultat trouvé."))
                      : ListView.builder(
                        itemCount: _resultats.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              leading: const Icon(Icons.home),
                              title: Text(_resultats[index]),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
