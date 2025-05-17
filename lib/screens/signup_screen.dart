import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yinzo/utils/pattern.dart';
import 'package:yinzo/widgets_function/build_textfield.dart';
import 'dart:io';

import 'package:yinzo/widgets_function/show_modal_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool hidePassword = true;

  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _pickImage({required ImageSource source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Envoyer les données
      print({
        "username": _usernameController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "photo": _profileImage?.path,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Logo
              Image.asset("assets/images/yinzo_logo_launcher.png", height: 150),
              const SizedBox(height: 20),
              Text(
                "Bienvenue sur Yinzo",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Inscrivez-vous pour continuer",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Image Picker
                    GestureDetector(
                      onTap: () async {
                        await showModalDialog(
                          context,
                          onTakePhoto: () {
                            // Pick image from camera
                            Navigator.of(context).pop();
                            _pickImage(source: ImageSource.camera);
                          },
                          onImportPhoto: () {
                            // Pick image from gallery
                            Navigator.of(context).pop();
                            _pickImage(source: ImageSource.gallery);
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                        child:
                            _profileImage == null
                                ? const Icon(Icons.camera_alt, size: 30)
                                : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fields
                    buildTextField(
                      _usernameController,
                      "Nom d'utilisateur",
                      Icons.person,
                    ),
                    buildTextField(_firstNameController, "Prénom", Icons.badge),
                    buildTextField(
                      _lastNameController,
                      "Nom",
                      Icons.badge_outlined,
                    ),
                    buildTextField(
                      _emailController,
                      "Email",
                      Icons.email,
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est requis';
                        }
                        final emailRegex = RegExp(emailPattern);
                        if (!emailRegex.hasMatch(value)) {
                          return 'Entrez un email valide';
                        }
                        return null;
                      },
                    ),
                    buildTextField(
                      _passwordController,
                      "Mot de passe",
                      Icons.lock,
                      isObscure: hidePassword,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return "Ce champ est requis";
                        }
                        final passwordRegex = RegExp(passwordPattern);
                        if (!passwordRegex.hasMatch(password)) {
                          return "Le mot de passe doit contenir au moins 8 caractères, une lettre et un chiffre";
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon:
                            hidePassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Vous avez déjà un compte ?",
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
