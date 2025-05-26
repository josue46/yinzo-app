import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Models/logement.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<LogementProvider>(context, listen: false).loadLogements();
  //   CategoryProvider.of(context, listen: false).loadCategories();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LogementProvider>(context, listen: false).loadLogements();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogementProvider>(
      builder: (context, provider, _) {
        final categories = CategoryProvider.of(context).categories;
        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            // Section Recherche
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      spreadRadius: -10,
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher un logement...",
                    hintStyle: const TextStyle(fontFamily: "Poppins"),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.white,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Catégories
            ShowCategories(
              categories: categories.map((category) => category.name).toList(),
              onCategorySelected: (slug) {
                if (slug == "tous") {
                  provider.loadLogements();
                } else {
                  provider.filterByCategory(slug);
                }
              },
            ),

            const SizedBox(height: 10),

            if (provider.isLoading)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 2,
                ),
                child: CircularProgressIndicator(),
              )
            else
              provider.logements.isEmpty
                  ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width / 2,
                    ),
                    child: const Text(
                      "Aucun logement trouvé !",
                      style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                    ),
                  )
                  :
                  // Liste des logements
                  Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: provider.logements.length,
                      itemBuilder: (context, index) {
                        Logement logement = provider.logements[index];
                        final photoUrl = logement.owner["photo"];

                        return Column(
                          children: [
                            const SizedBox(height: 30),

                            // Profil propriétaire
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: ListTile(
                                title: Text(
                                  "${logement.owner["first_name"]} ${logement.owner["last_name"]}",
                                ),
                                subtitle: Text(
                                  '@${logement.owner["username"]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  right: 0.8,
                                ),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      (photoUrl != null &&
                                              photoUrl.toString().isNotEmpty)
                                          ? NetworkImage(photoUrl)
                                          : const AssetImage(
                                                "assets/images/profil.jpg",
                                              )
                                              as ImageProvider,
                                ),
                              ),
                            ),

                            // Présentation logement
                            LogementArray(logement: logement),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
