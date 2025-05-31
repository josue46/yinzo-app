import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Models/logement.dart';
import 'package:yinzo/Users/Provider/user_logement_provider.dart';

class UserLogementScreen extends StatefulWidget {
  final String token;
  const UserLogementScreen({super.key, required this.token});
  // This screen displays the user's logements
  // It fetches the logements from the API and displays them in a list
  // Each logement can be edited or deleted
  // It also allows the user to navigate to the logement details screen

  @override
  State<UserLogementScreen> createState() => _UserLogementScreenState();
}

class _UserLogementScreenState extends State<UserLogementScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final logementProvider = Provider.of<UserLogementProvider>(
        context,
        listen: false,
      );
      logementProvider.fetchLogements(widget.token).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors du chargement des logements : $error"),
          ),
        );
      });
    });
  }

  Widget buildLogementCard(Logement logement) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/logementDetails',
            arguments: {'logementId': logement.id},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl:
                  logement.images.isNotEmpty
                      ? logement.images[0]
                      : 'https://via.placeholder.com/150',
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    logement.address,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${logement.numberOfRooms} chambre${logement.numberOfRooms > 1 ? 's' : ''} • ${logement.category}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prix ${logement.rentPrice} \$ / Mois • Garantie : ${logement.warranty} ${logement.commissionMonth != null && logement.commissionMonth! > 0 ? '+ ${logement.commissionMonth}' : ''} Mois',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    logement.numberScheduledVisits! > 0
                        ? '${logement.numberScheduledVisits} visite${logement.numberScheduledVisits! > 1 ? 's' : ''} planifiée${logement.numberScheduledVisits! > 1 ? 's' : ''}'
                        : "Vous n'avez pas de visites planifiées pour ce logement.",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 4.0,
                        children: [
                          const Icon(Icons.bar_chart),
                          Text("${logement.reviews}"),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 4.0,
                        children: [
                          const Icon(Icons.mode_comment_outlined),
                          Text("${logement.numberComments}"),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      const Wrap(
                        direction: Axis.horizontal,
                        spacing: 4.0,
                        children: [
                          Icon(Icons.favorite_border_outlined),
                          Text("18"),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 4.0,
                        children: [
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text("${logement.averageRating}"),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Action modifier
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          // Action supprimer
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Logements"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final logementProvider = Provider.of<UserLogementProvider>(
                context,
                listen: false,
              );
              logementProvider.fetchLogements(widget.token).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Erreur lors du rafraîchissement : $error"),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Consumer<UserLogementProvider>(
        builder: (context, logementProvider, child) {
          if (logementProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (logementProvider.logements.isEmpty) {
            return const Center(child: Text("Aucun logement publié."));
          }

          return ListView.builder(
            itemCount: logementProvider.logements.length,
            itemBuilder: (context, index) {
              final logement = logementProvider.logements[index];
              return buildLogementCard(logement);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/publish/logement',
            arguments: {'token': widget.token},
          );
        },
        tooltip: 'Ajouter un logement',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_home_rounded, size: 30),
      ),
    );
  }
}
