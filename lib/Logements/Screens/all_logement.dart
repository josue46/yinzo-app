import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Providers/category_provider.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';
import 'package:yinzo/Logements/Widgets/logement_array.dart';
import 'package:yinzo/Logements/Widgets/show_categories.dart';

class AllLogementScreen extends StatefulWidget {
  const AllLogementScreen({super.key});

  @override
  State<AllLogementScreen> createState() => _AllLogementScreenState();
}

class _AllLogementScreenState extends State<AllLogementScreen> {
  final _searchController = TextEditingController();
  final String _baseUrl = "http://192.168.29.146:8000";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LogementProvider>(context, listen: false).loadLogements();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  // void _onSearch() {
  //   final query = _searchController.text.trim();
  //   if (query.isNotEmpty) {
  //     Provider.of<LogementProvider>(context, listen: false).searchLogement(query);
  //   } else {
  //     Provider.of<LogementProvider>(context, listen: false).loadLogements();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LogementProvider, CategoryProvider>(
      builder: (context, logementProvider, categoryProvider, _) {
        final logements = logementProvider.logements;
        final categories = categoryProvider.categories;

        if (categories.isEmpty && logementProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          body: SafeArea(
            child: Column(
              children: [
                // Zone de recherche
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    // onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: "Rechercher un logement...",
                      hintStyle: const TextStyle(fontFamily: "Poppins"),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                        // onPressed: _onSearch,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Catégories
                ShowCategories(
                  categories:
                      categories
                          .map((cat) => {"name": cat.name, "slug": cat.slug})
                          .toList(),
                  onCategorySelected: (slug) {
                    if (slug.toLowerCase() == "tous") {
                      logementProvider.loadLogements();
                    } else {
                      logementProvider.filterByCategory(slug.toLowerCase());
                    }
                  },
                ),

                const SizedBox(height: 10),

                // Liste des logements
                Expanded(
                  child:
                      logementProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : logements.isEmpty
                          ? const Center(
                            child: Text(
                              "Aucun logement trouvé !",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins",
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            itemCount: logements.length,
                            itemBuilder: (context, index) {
                              final logement = logements[index];
                              final owner = logement.owner;

                              // Gestion de l'image du propriétaire
                              String photoPath = owner["photo"];
                              String photoUrl;

                              if (photoPath.isNotEmpty) {
                                if (photoPath.startsWith("/")) {
                                  photoUrl = '$_baseUrl$photoPath';
                                } else if (photoPath.startsWith("http") ||
                                    photoPath.startsWith("https")) {
                                  photoUrl = photoPath;
                                } else {
                                  photoUrl = '$_baseUrl/$photoPath';
                                }
                              } else {
                                // Si l'utilisateur n'a pas de photo de profile
                                photoUrl = "";
                              }

                              return Card(
                                margin: const EdgeInsets.only(bottom: 20),
                                color: Color(0xFFF8F8F8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Profil propriétaire
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          radius: 28,
                                          backgroundImage:
                                              photoUrl.isNotEmpty
                                                  ? NetworkImage(photoUrl)
                                                  : const AssetImage(
                                                        "assets/images/profil.jpg",
                                                      )
                                                      as ImageProvider,
                                        ),
                                        title: Text(
                                          "${owner["first_name"]} ${owner["last_name"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text("@${owner["username"]}"),
                                      ),

                                      const SizedBox(height: 10),

                                      // Détails du logement
                                      LogementArray(logement: logement),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
