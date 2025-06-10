import 'package:flutter/material.dart';

class OtherConnectionProviders extends StatelessWidget {
  final bool forAuthentication;
  const OtherConnectionProviders({super.key, this.forAuthentication = true});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        InkWell(
          onTap: () {
            if (forAuthentication) {
              debugPrint("Authentification par google");
            } else {
              debugPrint("Inscription par google");
            }
          },
          child: Material(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Colors.white,
            child: Ink(
              height: 50,
              width: 50,
              child: Image.asset("assets/images/google.png"),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 15)),
        InkWell(
          onTap: () {
            if (forAuthentication) {
              debugPrint("Authentification par facebook");
            } else {
              debugPrint("Inscription par facebook");
            }
          },
          child: Material(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Colors.white,
            child: Ink(
              height: 50,
              width: 50,
              child: Icon(Icons.facebook, color: Colors.blueAccent, size: 50),
            ),
          ),
        ),
      ],
    );
  }
}
