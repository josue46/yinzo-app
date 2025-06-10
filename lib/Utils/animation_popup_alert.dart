import 'package:flutter/material.dart';

void animationPopupAlert(context) async {
  await showGeneralDialog(
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 700),
    barrierColor: Colors.black.withValues(alpha: 0.4),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.2,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutQuart)),
        child: AlertDialog(
          elevation: 10,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Délai écoulé",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              InkWell(
                child: Icon(Icons.close, color: Colors.red),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: const <Widget>[
                    Icon(Icons.info_outline, color: Colors.red, size: 45),
                    SizedBox(height: 16),
                    Text(
                      style: TextStyle(fontFamily: 'Inter', fontSize: 18),
                      "Votre compte est désormais désactivé et sera définitivement supprimé après 24H. Cette mesure est prise pour assurer la fiabilité de notre plateforme. Veuillez nous contacter si vous voulez récupérer votre compte, ou créez-en un autre.",
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(shape: StadiumBorder()),
              child: const Text('Nous contacter'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Créer un nouveau compte'),
            ),
          ],
        ),
      );
    },
  );
}
