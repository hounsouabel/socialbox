import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe7/screens/account_recovery.dart';
import 'package:groupe7/screens/home_page.dart';
import 'package:groupe7/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'inscription/page1.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un e-mail valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> _saveLoginInformation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_password', _passwordController.text.trim());

      _showToast('Informations enregistrées avec succès !');
    } catch (e) {
      _showToast('Erreur d\'enregistrement : ${e.toString()}');
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() != true) {
      _showToast('Veuillez corriger les erreurs');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (_rememberMe) {
        await _saveLoginInformation();
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChatterBox()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showToast(_getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  ///J'essaie d'afficher les bons toast....
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'L\'adresse e-mail est invalide';
        case 'wrong-password':
          return 'Mot de passe incorrect';
        case 'user-not-found':
          return 'Aucun compte trouvé avec cet e-mail';
        case 'user-disabled':
          return 'Ce compte a été désactivé';
        case 'email-already-in-use':
          return 'Cet e-mail est déjà utilisé';
        case 'too-many-requests':
          return 'Trop de tentatives, réessayez plus tard';
        case 'operation-not-allowed':
          return 'Connexion par e-mail désactivée';
        case 'network-request-failed':
          return 'Vérifiez votre connexion Internet';
        case 'weak-password':
          return 'Le mot de passe est trop faible';
        case 'invalid-credential':
          return 'Identifiants invalides, vérifiez votre e-mail et mot de passe';
        case 'account-exists-with-different-credential':
          return 'Ce compte est déjà utilisé avec une autre méthode';
        case 'invalid-verification-code':
          return 'Le code de vérification est incorrect';
        case 'invalid-verification-id':
          return 'Problème de vérification, réessayez';
        case 'quota-exceeded':
          return 'Trop de tentatives, veuillez attendre quelques minutes';
        case 'recaptcha-check-failed':
          return 'Vérification reCAPTCHA échouée, réessayez';
        default:
          return 'Erreur de connexion: ${error.message}';
      }
    } else if (error is FirebaseException) {
      // Gérer certains codes spécifiques si besoin
      switch (error.code) {
        case 'too-many-requests':
          return 'Trop de tentatives, veuillez attendre quelques minutes';
        case 'invalid-credential':
          return 'Identifiants invalides, vérifiez votre e-mail et mot de passe';
        default:
          return 'Erreur de connexion: ${error.message}';
      }
    } else if (error.toString().contains('incorrect, malformed or has expired')) {
      // Cas spécifique pour le message d'erreur que vous observez
      return 'Identifiants incorrects ou expirés';
    }
    return 'Une erreur est survenue, réessayez';
  }



  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    "assets/logo-removebg-preview.png",
                    height: 130,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Connectez-vous",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            filled: true,
                            fillColor: Color(0xFFFAECF5),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isObscure,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Mot de passe',
                              filled: true,
                              fillColor: const Color(0xFFFAECF5),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                        ),
                        CheckboxListTile(
                          title: const Text('Se souvenir de moi'),
                          value: _rememberMe,
                          activeColor: Colors.pink,
                          checkColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                              color: Colors.pink),
                        )
                            : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFBA0572),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Se connecter"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountRecoveryScreen()),
                            );
                          },
                          child: Text(
                            'Mot de passe oublié?',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Page1()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Vous n'avez pas de compte? ",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              children: const [
                                TextSpan(
                                  text: "Inscrivez-vous",
                                  style: TextStyle(color: Color(0xFFBA0572)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}