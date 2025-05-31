import 'package:flutter/material.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';
import 'package:yinzo/Users/Widgets/build_textfield.dart';
import 'package:yinzo/Users/Widgets/other_connection_providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  late final AuthProvider _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthProvider.of(context, listen: false);
  }

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Connexion en cours..."),
          ],
        ),
        duration: Duration(minutes: 1), // Longue durée qui sera annulée
      ),
    );

    try {
      final result = await _auth.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (result != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: ${e.toString()}")),
      );
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
              // Logo Yinzo
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
                "Connectez-vous pour continuer",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Login form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    BuildTextfield(
                      controller: _usernameController,
                      hint: "Nom d'utilisateur ou Email",
                      icon: Icons.person_2,
                      inputType: TextInputType.emailAddress,
                    ),

                    // Password
                    BuildTextfield(
                      controller: _passwordController,
                      hint: "Mot de passe",
                      icon: Icons.lock,
                      isObscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _submitLogin();
                      },
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 16,
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
                          "Pas encore de compte ?",
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(
                            "S'inscrire",
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
                    const SizedBox(height: 20),
                    otherConnectionProviders(forAuthentication: true),
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
