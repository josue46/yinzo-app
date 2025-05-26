import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yinzo/Users/Screens/profile_details_screen.dart';
import 'package:yinzo/Utils/svg_pattern.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Paramètres",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  "Mettez à jour vos paramètres tels que le thème, la modification de votre profil, etc.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ProfileMenuCard(
                  svgSrc: profileIconSvg,
                  title: "Informations sur le profil",
                  subTitle: "Modifier les informations de votre compte",
                  press: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
                    );
                  },
                ),
                ProfileMenuCard(
                  svgSrc: lockIconSvg,
                  title: "Changer le mot de passe",
                  subTitle: "Changer votre mot de passe",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: shareIconSvg,
                  title: "Thème",
                  subTitle: "Changer le thème de l'application",
                  press: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    this.title,
    this.subTitle,
    this.svgSrc,
    this.press,
  });

  final String? title, subTitle, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SvgPicture.string(
                svgSrc!,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF010F07).withOpacity(0.64),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF010F07).withOpacity(0.54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_outlined, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
