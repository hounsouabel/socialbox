import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page5.dart';
import 'package:groupe7/inscription/verification_page.dart';
import 'package:groupe7/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Page6 extends StatefulWidget {
  const Page6({super.key});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  bool _isObscure = true;
  bool _isLoading = false;

  final _passwordController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> _handlePass() async {
    final password = _passwordController.text;
    final validationResult = _validatePassword(password);

    if (validationResult == null) {
      if (inscriptionData.email.isEmpty ||
          inscriptionData.firstname.isEmpty ||
          inscriptionData.lastname.isEmpty ||
          inscriptionData.birthDate == null ||
          inscriptionData.gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certaines informations sont manquantes.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      AuthService authService = AuthService();

      try {
        // Vérifie si l'email est déjà utilisé
        // ignore: deprecated_member_use
        final query = await FirebaseAuth.instance.fetchSignInMethodsForEmail(inscriptionData.email);

        if (query.isNotEmpty) {
          // Si l'email existe déjà, redirige vers Page5
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Page5()),
          );
          return;
        }

        // Création de l'utilisateur
        await authService.signUpUser(
          email: inscriptionData.email,
          password: password,
          firstName: inscriptionData.firstname,
          lastName: inscriptionData.lastname,
          birthDate: inscriptionData.birthDate,
          gender: inscriptionData.gender,
          pseudo: inscriptionData.pseudo,
        );

        // Envoie l'e-mail de vérification
        await authService.sendEmailVerification();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Un e-mail de vérification a été envoyé.')),
        );


        //sauvegarde le mdp dans InscriptionData
        inscriptionData.password=password;


        // Redirige vers la page de vérification
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerificationPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationResult)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[30],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 45),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page5()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Créez un mot de passe',
              style: TextStyle(
                fontSize: 30,
                
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Créez un mot de passe comprenant au moins 6 caractères.',
              style: TextStyle(fontSize: 15, ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock, color: Colors.blue),
                      labelText: 'Mot de passe',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handlePass,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Suivant',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
