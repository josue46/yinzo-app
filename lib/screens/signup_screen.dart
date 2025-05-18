import 'package:flutter/material.dart';
import 'package:yinzo/core/providers/auth_provider.dart';
import 'package:yinzo/utils/pattern.dart';
import 'package:yinzo/widgets/column_display_for_login_prompt.dart';
import 'package:yinzo/widgets/row_display_for_login_prompt.dart';
import 'package:yinzo/widgets_function/build_textfield.dart';
import 'package:yinzo/widgets_function/other_connection_providers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = AuthProvider.of(context, listen: false);

      final errorMessage = await provider.signup(
        username: _usernameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red.shade600,
          ),
        );
      } else {
        // Rediriger uniquement si tout est OK
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
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
                      child:
                          AuthProvider.of(context).isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Créer un compte",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                    ),
                    const SizedBox(height: 20),
                    MediaQuery.of(context).size.width >= 360
                        ? RowDisplayForLoginPrompt()
                        : ColumnDisplayForLoginPrompt(),
                    const SizedBox(height: 20),
                    otherConnectionProviders(forAuthentication: false),
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
