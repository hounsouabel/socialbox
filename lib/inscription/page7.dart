// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/screens/home_page.dart';
import 'package:groupe7/home.dart';
import 'package:groupe7/inscription/page6.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page7 extends StatefulWidget {
  const Page7({
    super.key,
  });

  @override
  State<Page7> createState() => _Page7State();
}

class _Page7State extends State<Page7> {
  Future<void> _saveLoginInformation(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Informations enregistrées avec succès !')),
      );

      // Redirection après l'enregistrement
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChatterBox()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail =
        inscriptionData.email; // Récupère l'e-mail utilisateur
    final String userPassword =
        inscriptionData.password; // Récupère le mot de passe utilisateur

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
                icon:
                    const Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page6()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enregistrer vos informations de connexion ?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nous enregistrerons vos informations de connexion afin que vous n\'ayez pas à les entrer lors de votre prochaine connexion.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveLoginInformation(userEmail, userPassword),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: Colors.blue),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.pink[30],
              ),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
