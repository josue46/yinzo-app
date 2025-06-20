import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Providers/category_provider.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';
import 'package:yinzo/Logements/Widgets/logement_array.dart';
import 'package:yinzo/Logements/Widgets/show_categories.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';
import 'package:yinzo/Utils/handle_logement_owner_photo.dart';

class AllLogementScreen extends StatefulWidget {
  const AllLogementScreen({super.key});

  @override
  State<AllLogementScreen> createState() => _AllLogementScreenState();
}

class _AllLogementScreenState extends State<AllLogementScreen> {
  final _searchController = TextEditingController();
  final String _baseUrl = DioService.baseUrl;

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
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _searchController.clear(),
                              )
                              : null,
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
                  onCategorySelected: (slug) async {
                    if (slug == "tous") {
                      await logementProvider.loadLogements();
                    } else {
                      await logementProvider.filterByCategory(slug);
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
                              String photoUrl =
                                  handleThePhotoOfTheLogementOwner(
                                    owner,
                                    _baseUrl,
                                  );

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
                                                  ),
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
