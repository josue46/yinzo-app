import 'package:flutter/material.dart';
import 'package:yinzo/screens/logement_detail_screen.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:yinzo/screens/messages_screen.dart';
import 'package:yinzo/widgets/show_categories.dart';

class AllLogementWidget extends StatefulWidget {
  const AllLogementWidget({super.key});

  @override
  State<AllLogementWidget> createState() => _AllLogementWidgetState();
}

class _AllLogementWidgetState extends State<AllLogementWidget> {
  bool _isFavorite = false;
  final List<String> imageUrls = [
    "assets/images/unnamed.jpg",
    "assets/images/project_991124655c6f6da43bf_pic_1.webp",
    "assets/images/Villa-moderne-1-scaled.jpg",
    "assets/images/myimg.jpg",
  ];
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section for Search
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: -10,
                  color: Colors.black,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              // onChanged: provider.setSearchQuery,
              decoration: InputDecoration(
                hintText: "Rechercher un logement...",
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

        // Categories
        ShowCategories(
          categories: ["Tous", "Maisons", "Appartements", "Studios"],
        ),
        const SizedBox(height: 10),

        // Section for listing logements
        Expanded(
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ListTile(
                      title: const Text("Luis Martin's"),
                      subtitle: const Text(
                        "Propriétaire",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      contentPadding: const EdgeInsets.only(right: 0.8),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/profil.jpg"),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 12,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => LogementDetailsScreen(),
                                  ),
                                );
                              },
                              child: FlutterCarousel.builder(
                                options: FlutterCarouselOptions(
                                  enableInfiniteScroll: true,
                                  autoPlay: true,
                                  autoPlayCurve: Curves.easeInOut,
                                  viewportFraction: 1.0,
                                  autoPlayAnimationDuration: const Duration(
                                    milliseconds: 1500,
                                  ),
                                ),
                                itemCount: imageUrls.length,
                                itemBuilder: (context, index, _) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      imageUrls[index],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Favorite icon
                            Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.white60,
                                  iconSize: 25,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                },
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite_outlined
                                      : Icons.favorite_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Maison à louer",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.star,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "4.5",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                "Kinshasa",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "150\$",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: Icon(Icons.phone),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(200, 45),
                                      ),
                                      label: const Text(
                                        "Appeler",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.chat),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(200, 45),
                                        shape: StadiumBorder(),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      label: const Text(
                                        "Message",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (ctx) => MessagesScreen(
                                                  username: "Josué Luis",
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
