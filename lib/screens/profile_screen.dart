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
  final _formKey2 = GlobalKey<FormState>();
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        // backgroundColor: Color(0xF5F5F5F5),
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
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 340,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(-2, 2),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
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
                                  // Formulaire de changement de mot de passe
                                  changeNewPasswordForm(context, primaryColor),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.add_home_rounded,
                    title: 'Ajouter un logement',
                    onTap: () {},
                  ),
                  buildProfileTile(
                    icon: Icons.settings,
                    title: 'Paramètres',
                    onTap: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
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

  Form changeNewPasswordForm(BuildContext context, Color primaryColor) {
    return Form(
      key: _formKey2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MyCustomForm(
              autofocus: true,
              label: 'Ancien mot de passe',
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Ce champ ne doit pas être vide";
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            MyCustomForm(
              label: 'Nouveau mot de passe',
              controller: _newPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Ce champ ne doit pas être vide";
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            MyCustomForm(
              label: 'Confirmer le mot de passe',
              controller: _confirmPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Ce champ ne doit pas être vide";
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            // Bouton pour enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey2.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Votre mot de passe à été modifié avec succès ✅',
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Changer le mot de passe",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  editProfileModal(BuildContext context, Color primaryColor) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 500,
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
                      const SizedBox(height: 20),
                      // Bouton pour enregistrer
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Enregistrer",
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
