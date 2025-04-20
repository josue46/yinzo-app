import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:yinzo/screens/messages_screen.dart';

class LogementDetailsScreen extends StatefulWidget {
  const LogementDetailsScreen({super.key});

  @override
  State<LogementDetailsScreen> createState() => _LogementDetailsScreenState();
}

class _LogementDetailsScreenState extends State<LogementDetailsScreen> {
  final List<String> imageUrls = [
    'assets/images/premium_photo.jpeg',
    'assets/images/Best_Modern_House_Design.jpg',
    'assets/images/Front_main_page.jpg',
    'assets/images/Gallery_House_Main.jpg',
  ];

  final List<Map<String, dynamic>> commentaires = [
    {
      "nom": "Kernel Malik",
      "texte": "Très bon logement, bien situé. J'aime bien !",
      "note": 4.5,
    },
    {
      "nom": "Josué P.",
      "texte": "Le propriétaire est très sympa !",
      "note": 5.0,
    },
    {
      "nom": "Luis M.",
      "texte": "Un peu éloigné du centre mais très calme.",
      "note": 3.5,
    },
    {
      "nom": "Ir Malik",
      "texte":
          "Les toilettes ne sont pas très moderne, mais à part ça j'ai bien aimé.",
      "note": 3.0,
    },
  ];

  double userRating = 3.5;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "150\$ mois",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    "3+1 Garantie",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(145, 45),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  "Réserver",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  FlutterCarousel(
                    options: FlutterCarouselOptions(
                      height: 300,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.easeInOut,
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 1500,
                      ),
                    ),
                    items:
                        imageUrls.map((url) {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            ),
                            child: Image.asset(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        }).toList(),
                  ),
                  Positioned(
                    top: 10,
                    left: 15,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                      ),
                      splashColor: Colors.white,
                      icon: Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      icon: Icon(Icons.favorite_outline),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Détails
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Maison à louer - Gombe",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => MessagesScreen(username: "Luis"),
                              ),
                            );
                          },
                          child: Icon(Icons.message_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "2 chambres, 1 salon, cuisine, salle de bain",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // Notation
                    const Text(
                      "Notez ce logement",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          userRating = rating;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // ✍️ Commentaire
                    const Text(
                      "Laissez un avis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Votre avis...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 19),
                        iconSize: 19,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        final comment = _commentController.text;
                        if (comment.isNotEmpty) {
                          setState(() {
                            commentaires.insert(0, {
                              "nom": "Vous",
                              "texte": comment,
                              "note": userRating,
                            });
                            _commentController.clear();
                          });
                        }
                      },
                      label: const Text("Envoyer"),
                      icon: const Icon(Icons.send),
                    ),
                    const SizedBox(height: 30),

                    // 💬 Liste des avis
                    const Text(
                      "Avis des utilisateurs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...commentaires.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ListTile(
                            tileColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            title: Text(
                              comment['nom'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                RatingBarIndicator(
                                  rating: comment['note'],
                                  itemBuilder:
                                      (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                  itemCount: 5,
                                  itemSize: 18,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(height: 4),
                                Text(comment['texte']),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
