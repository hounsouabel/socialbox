import 'package:flutter/material.dart';
import 'package:groupe7/screens/account_recovery.dart';
import 'package:groupe7/screens/home_page.dart';
import 'package:groupe7/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inscription/page1.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isObscure = true;
  bool _isLoading = false;

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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informations enregistrées avec succès !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'enregistrement : $e')),
        );
      }
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez corriger les erreurs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Afficher la boîte de dialogue d'enregistrement
      final saveCredentials = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enregistrer les identifiants'),
          content: const Text('Voulez-vous enregistrer vos informations de connexion ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      );

      if (saveCredentials == true) {
        await _saveLoginInformation();
      }

      // Redirection vers la page d'accueil
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChatterBox()),
            (Route<dynamic> route) => false,
      );

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
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
                        SizedBox(height: 20),
                        _isLoading
                            ? Center(child: CircularProgressIndicator(color: Colors.pink),)
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
                              MaterialPageRoute(builder: (context) => AccountRecoveryScreen()),
                            );
                          },
                          child: Text(
                            'Mot de passe oublié?',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,),
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
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,),
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