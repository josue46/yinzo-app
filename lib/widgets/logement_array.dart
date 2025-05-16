import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:yinzo/models/logement.dart';
import 'package:yinzo/screens/logement_detail_screen.dart';
import 'package:yinzo/screens/messages_screen.dart';

class LogementArray extends StatelessWidget {
  const LogementArray({super.key, required this.logement});

  final Logement logement;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
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
                          (context) =>
                              LogementDetailsScreen(logementId: logement.id),
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
                  itemCount: logement.images.length,
                  itemBuilder: (context, index, _) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: logement.images[index],
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.broken_image, size: 50),
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
                    // isFavorite = !isFavorite;
                  },
                  icon: Icon(Icons.favorite_outline),
                  // Icon(
                  //   isFavorite
                  //       ? Icons.favorite_outlined
                  //       : Icons.favorite_outline,
                  //   color: Theme.of(context).primaryColor,
                  // ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${logement.category} ${logement.forRent ? 'en location' : 'à vendre'} à ${logement.city}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.star,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          TextSpan(
                            text: logement.averageRating.toStringAsFixed(2),
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

                GestureDetector(
                  onTap: () {
                    print(logement.address);
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.pin_drop,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: 'À • ${logement.address}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${logement.numberOfRooms} chambre${logement.numberOfRooms > 1 ? 's' : ''} •',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Text(
                  "${logement.rentPrice}\$/mois",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          backgroundColor: Theme.of(context).primaryColor,
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
                                    username: logement.owner['username'],
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
    );
  }
}
