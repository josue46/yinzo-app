import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yinzo/Utils/svg_pattern.dart';
import 'package:yinzo/Widgets/error_info.dart';

class NoconnectionScreen extends StatelessWidget {
  const NoconnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    noCoonectionIllistration,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Opps!....",
                description:
                    "Quelque chose s'est mal passé avec votre connexion, S'il vous plaît réessayez après un moment.",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
