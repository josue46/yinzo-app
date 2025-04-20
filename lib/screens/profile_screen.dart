import 'package:flutter/material.dart';
import 'package:yinzo/widgets_function/build_profile.dart';
import 'package:yinzo/widgets/mycustom_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(
    text: "Josué",
  );
  final TextEditingController _firstNameController = TextEditingController(
    text: "Luis",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+243 842761741",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "josuepanzu8@gmail.com",
  );

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Photo de profil
            CircleAvatar(
              radius: 55,
              backgroundColor: primaryColor,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/profil.jpg',
                ), // Remplace par une image de profil
              ),
            ),
            const SizedBox(height: 10),
            // Nom de l'utilisateur
            const Text(
              'Josué Luis',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // Email
            const Text(
              'josuepanzu8@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Informations & actions
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildProfileTile(
                    icon: Icons.edit,
                    title: 'Modifier le profil',
                    onTap: () {
                      editProfileModal(context, primaryColor);
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.lock,
                    title: 'Changer le mot de passe',
                    onTap: () {},
                  ),
                  buildProfileTile(
                    icon: Icons.settings,
                    title: 'Paramètres',
                    onTap: () {},
                  ),
                  buildProfileTile(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    onTap: () {},
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PersistentBottomSheetController editProfileModal(
    BuildContext context,
    Color primaryColor,
  ) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 480,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: Offset(-2, 2),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: Container(
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nom
                      MyCustomForm(
                        autofocus: true,
                        controller: _nameController,
                        label: 'Nom',
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Le nom est obligatoire'
                                    : null,
                      ),
                      const SizedBox(height: 15),
                      // prénom
                      MyCustomForm(
                        controller: _firstNameController,
                        label: 'Prénom',
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Le prénom est obligatoire'
                                    : null,
                      ),
                      const SizedBox(height: 15),
                      // prénom
                      MyCustomForm(
                        controller: _emailController,
                        label: 'Email',
                        validator:
                            (value) =>
                                value == null ||
                                        value.isEmpty ||
                                        !value.contains("@")
                                    ? 'Entrez un email valide'
                                    : null,
                      ),
                      const SizedBox(height: 15),
                      // prénom
                      MyCustomForm(
                        controller: _phoneController,
                        label: 'Téléphone',
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 100),
                      // Bouton enregistrer
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Profil mis à jour avec succès ✅',
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                              );
                              Navigator.pop(context); // Retour à la page profil
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Enregistrer",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
