import 'package:flutter/material.dart';
import 'package:yinzo/utils/format_datetime.dart';
import 'package:icons_plus/icons_plus.dart' show Iconsax;

class ScheduledVisitScreen extends StatelessWidget {
  ScheduledVisitScreen({super.key});

  final List<Map<String, dynamic>> rendezVous = [
    {
      'proprietaire': 'Jean K.',
      'lieu': 'Gombe, Kinshasa',
      'logement': 'Appartement T3 - 2ème étage',
      'date': DateTime.now().add(Duration(days: 1, hours: 10)),
      'telephone': '+243 821 000 000',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
    {
      'proprietaire': 'Fatima B.',
      'lieu': 'Ngaliema, Kinshasa',
      'logement': 'Studio meublé',
      'date': DateTime.now().add(Duration(days: 3, hours: 15)),
      'telephone': '+243 990 111 222',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes rendez-vous"),
        backgroundColor: Color(0x00f8f9fa),
      ),
      body:
          rendezVous.isEmpty
              ? Center(
                child: const Text("Vous n'avez aucun rendez-vous planifié"),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rendezVous.length,
                itemBuilder: (context, index) {
                  final rdv = rendezVous[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rdv['logement'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(rdv['lieu']),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(formatDateTime(rdv['date'])),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text("Propriétaire : ${rdv['proprietaire']}"),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone),
                              label: const Text("Appeler"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Iconsax.message_text_1_bulk),
                              label: const Text("Envoyer un message"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
