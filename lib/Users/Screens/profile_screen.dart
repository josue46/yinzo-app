import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Pages/settings_screen.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';
import 'package:yinzo/Users/Screens/profile_details_screen.dart';
import 'package:yinzo/Users/Screens/user_logement_screen.dart';
import 'package:yinzo/Users/Widgets/profile_menu.dart';
import 'package:yinzo/Users/Widgets/profile_picture.dart';
import 'package:yinzo/Utils/svg_pattern.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuth();
    });
  }

  Future<void> _initializeAuth() async {
    final auth = AuthProvider.of(context, listen: false);
    await auth.initialize();

    // Si le token est expiré mais qu'on a un refresh token, on tente de rafraîchir
    if (auth.authStatus == AuthStatus.expired && auth.refreshToken != null) {
      await auth.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Photo de profil avec indicateur de connexion
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const ProfilePicture(),
                    if (auth.isConnected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section compte
                _buildSectionTitle("Mon compte"),
                ProfileMenu(
                  text: "Informations personnelles",
                  icon: profileIconSvg,
                  press: () => _navigateToProfileDetails(auth),
                ),
                ProfileMenu(
                  text: "Mes Logements",
                  icon: profileIconSvg,
                  press: () => _navigateToUserLogements(auth),
                ),

                // Section activités
                _buildSectionTitle("Mes activités"),
                ProfileMenu(
                  text: "Réservations",
                  icon: profileIconSvg,
                  press: () => _navigateToReservation(auth),
                ),
                ProfileMenu(
                  text: "Mes rendez-vous",
                  icon: profileIconSvg,
                  press: () => _navigateToScheduledVisit(auth),
                ),

                // Section préférences
                _buildSectionTitle("Préférences"),
                ProfileMenu(
                  text: "Notifications",
                  icon: notificationIconSvg,
                  press: () {},
                ),
                ProfileMenu(
                  text: "Paramètres",
                  icon: settingIconSvg,
                  press:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                ),
                ProfileMenu(
                  text: "Centre d'aide",
                  icon: helpIconSvg,
                  press: () {},
                ),

                // Bouton de connexion/déconnexion
                const SizedBox(height: 20),
                auth.isConnected
                    ? ProfileMenu(
                      text: "Se déconnecter",
                      icon: logOutIconSvg,
                      press: () => _logout(auth),
                      color: Colors.red,
                    )
                    : ProfileMenu(
                      text: "Se connecter",
                      icon: logOutIconSvg,
                      press: () => Navigator.pushNamed(context, "/login"),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToUserLogements(AuthProvider auth) async {
    if (!auth.isConnected) {
      _showAuthRequiredSnackbar("accéder à vos logements");
      return;
    }

    // Vérifie si le token est encore valide
    if (auth.authStatus == AuthStatus.expired) {
      await auth.refresh();
      if (!auth.isConnected) return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserLogementScreen(token: auth.accessToken!),
      ),
    );
  }

  Future<void> _navigateToReservation(AuthProvider auth) async {
    if (!auth.isConnected) {
      _showAuthRequiredSnackbar("accéder à vos reservations");
      return;
    }

    // Vérifie si le token est encore valide
    if (auth.authStatus == AuthStatus.expired) {
      await auth.refresh();
      if (!auth.isConnected) return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserLogementScreen(token: auth.accessToken!),
      ),
    );
  }

  Future<void> _navigateToScheduledVisit(AuthProvider auth) async {
    if (!auth.isConnected) {
      _showAuthRequiredSnackbar("accéder à rendez-vous");
      return;
    }

    // Vérifie si le token est encore valide
    if (auth.authStatus == AuthStatus.expired) {
      await auth.refresh();
      if (!auth.isConnected) return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserLogementScreen(token: auth.accessToken!),
      ),
    );
  }

  Future<void> _navigateToProfileDetails(AuthProvider auth) async {
    if (!auth.isConnected) {
      _showAuthRequiredSnackbar("accéder à votre profil");
      return;
    }

    if (auth.authStatus == AuthStatus.expired) {
      await auth.refresh();
      if (!auth.isConnected) return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()),
    );
  }

  void _showAuthRequiredSnackbar(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text("Veuillez vous connecter pour $action."),
        action: SnackBarAction(
          label: "Se connecter",
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pushNamed(context, "/login"),
        ),
      ),
    );
  }

  Future<void> _logout(AuthProvider auth) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await auth.logout();
      scaffold.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text("Vous êtes maintenant déconnecté"),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la déconnexion: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
