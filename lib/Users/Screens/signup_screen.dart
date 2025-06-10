import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yinzo/Logements/Screens/publish_logement_screen.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';
import 'package:yinzo/Users/Widgets/build_textfield.dart';
import 'package:yinzo/Users/Widgets/column_display_for_login_prompt.dart';
import 'package:yinzo/Users/Widgets/other_connection_providers.dart';
import 'package:yinzo/Users/Widgets/row_display_for_login_prompt.dart';
import 'package:yinzo/Utils/pattern.dart';
import 'package:yinzo/Widgets/temporary_account_countdown_listener.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countDownTimer = GlobalKey<TemporaryAccountCountdownListenerState>();
  bool hidePassword = true;

  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // A note that warns the user that their account will only be
  // available after publishing a first logement for their account.
  _userNotice() async {
    const String notice =
        "Veuillez noter que votre compte ne sera activé qu'après avoir publié votre premier logement. Cette mesure est prise pour assurer la qualité de notre plateforme.";
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (ctx, anim1, anim2) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.7,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notice importante",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                          CurvedAnimation(
                            parent: anim1,
                            curve: const Interval(
                              0.1,
                              0.5,
                              curve: Curves.elasticOut,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: anim1,
                            curve: Interval(0.3, 0.7, curve: Curves.easeOut),
                          ),
                        ),
                        child: const Text(
                          notice,
                          style: TextStyle(fontFamily: 'Inter'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: anim1,
                            curve: const Interval(
                              0.5,
                              1.0,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("J'ai compris"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = AuthProvider.of(context, listen: false);
      final ThemeData theme = Theme.of(context);

      final confirm = await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (ctx) => AlertDialog(
              elevation: 5,
              backgroundColor: Colors.white,
              title: const Text("Confirmation"),
              content: const Text(
                "Votre compte sera activé après avoir publié votre premier logement. Souhaitez-vous continuer ?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    "Annuler",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    "Continuer",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
              ],
            ),
      );

      if (!confirm) return;

      final message = await provider.signup(
        username: _usernameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (message == 'success') {
        // Lance le timer and redirection vers l'écran de publication.
        _saveTemporaryAccountExpirationDate();
        _countDownTimer.currentState!.startTimer();
        await _showSuccessAndRedirect();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Future<void> _saveTemporaryAccountExpirationDate() async {
    final prefs = await SharedPreferences.getInstance();
    final expirationDate = DateTime.now().add(const Duration(minutes: 15));
    prefs.setString(
      'temporaryAccountExpirationDate',
      expirationDate.toIso8601String(),
    );
  }

  Future<void> _showSuccessAndRedirect() async {
    final ThemeData theme = Theme.of(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder:
          (context) => AlertDialog(
            title: const Text("Inscription réussie !"),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 20),
                const Text(
                  "Votre compte a été créé avec succès. "
                  "Pour l'activer, veuillez publier votre premier logement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Redirection vers l'écran de publication
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => PublishLogementScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Publier mon premier logement",
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 900), () => _userNotice());
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
              // Info Row
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    "Le compte sera activé après publication d'un logement",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Fields
                    BuildTextfield(
                      controller: _usernameController,
                      hint: "Nom d'utilisateur",
                      icon: Icons.person,
                    ),
                    BuildTextfield(
                      controller: _firstNameController,
                      hint: "Prénom",
                      icon: Icons.badge,
                    ),
                    BuildTextfield(
                      controller: _lastNameController,
                      hint: "Nom",
                      icon: Icons.badge_outlined,
                    ),
                    BuildTextfield(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email,
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
                    BuildTextfield(
                      controller: _passwordController,
                      hint: "Mot de passe",
                      icon: Icons.lock,
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _submitForm();
                      },
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
                    OtherConnectionProviders(forAuthentication: false),
                  ],
                ),
              ),
              TemporaryAccountCountdownListener(
                key: _countDownTimer,
                launchFromSignupScreen: true,
                showTimer: false,
                child: const SizedBox.shrink(),
                onExpired: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
