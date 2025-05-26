import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Chat/Screens/messages_screen.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LogementDetailsScreen extends StatefulWidget {
  LogementDetailsScreen({super.key, required this.logementId});

  String logementId;

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

  int currentImage = 1;
  double userRating = 3.5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<LogementProvider>(
      context,
      listen: false,
    ).loadLogementDetails(logementId: widget.logementId);
  }

  @override
  Widget build(BuildContext context) {
    final logement = Provider.of<LogementProvider>(context).logementDetails;
    if (logement == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final commission = logement.commissionMonth;
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
                    "${logement.rentPrice}\$ mois",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Garantie ${logement.warranty}${commission != 0 ? '+$commission' : ''} mois",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(145, 45),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  "Réserver",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
        body: Consumer<LogementProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final logement = provider.logementDetails!;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      FlutterCarousel(
                        options: FlutterCarouselOptions(
                          height: 400,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          showIndicator: false,
                          onPageChanged: (index, _) {
                            currentImage = index + 1;
                            setState(() {});
                          },
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 1500,
                          ),
                        ),
                        items:
                            logement.images.map((url) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2),
                                  bottomRight: Radius.circular(2),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                      ),
                                ),
                              );
                            }).toList(),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 25,
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Center(
                            child: Text(
                              "$currentImage/${logement.images.length}",
                            ),
                          ),
                        ),
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

                  const Padding(padding: EdgeInsets.only(top: 5)),

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
                              "${logement.category} à ${logement.forRent ? "louer" : "vendre"}, ${logement.city}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(width: 5),
                                propositionModal(context),
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                        Text(
                          "${logement.numberOfRooms} chambre${logement.numberOfRooms > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                        Text(
                          logement.description,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        const Divider(),
                        Text(
                          "Ce logement est proposé par",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        ListTile(
                          leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundImage: NetworkImage(
                              logement.owner["photo"],
                            ),
                          ),
                          title: Text(
                            "${logement.owner["first_name"]} ${logement.owner["last_name"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "@${logement.owner["username"]}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                                icon: Icon(Icons.phone),
                                onPressed: () {
                                  // Logique pour passer un appel
                                },
                              ),
                              const Padding(padding: EdgeInsets.only(right: 8)),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                                icon: Icon(Icons.chat),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => MessagesScreen(
                                            username:
                                                "${logement.owner["first_name"]} ${logement.owner["last_name"]}",
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 15),

                        // Liste des avis
                        Text(
                          "Avis des utilisateurs (${logement.numberComments} avis)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),

                        ...provider.commentsLogement.map((comment) {
                          return displayCommentInfos(comment);
                        }),
                        const SizedBox(height: 30),
                        // Notation
                        const Text(
                          "",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ✍️ Commentaire
                        const Text(
                          "Laissez votre avis et une note pour ce logement",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        const SizedBox(height: 10),
                        Card(
                          color: Colors.white,
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
                                provider.commentsLogement.insert(0, {
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Padding displayCommentInfos(comment) {
    final DateTime commentDate = DateTime.parse(comment['timestamp']);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          title: Text(
            '@${comment['author']['username']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              RatingBarIndicator(
                rating: comment["author"]["note"],
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 18,
                direction: Axis.horizontal,
              ),
              Row(
                children: [
                  const Text(
                    "Publié le",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Text(DateFormat("dd/MM/yyyy").format(commentDate)),
                ],
              ),
              const SizedBox(height: 10),
              Text(comment['content']),
            ],
          ),
        ),
      ),
    );
  }

  InkWell propositionModal(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              height: 210,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.chat),
                      title: Text("Envoyer un message au propriétaire"),
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MessagesScreen(username: "Luis"),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_forwarded),
                      iconColor: Theme.of(context).colorScheme.primary,
                      title: Text("Passer un appel au propriétaire"),
                      onTap: () {
                        // Logique pour passer un appel
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.report),
                      iconColor: Theme.of(context).colorScheme.primary,
                      title: Text("Signaler ce logement"),
                      onTap: () {
                        // Logique pour signaler le logement
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.block),
                      iconColor: Theme.of(context).colorScheme.primary,
                      title: Text("Bloquer l'utilisateur"),
                      onTap: () {
                        // Logique pour bloquer l'utilisateur
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Icon(Icons.more_vert),
    );
  }
}
