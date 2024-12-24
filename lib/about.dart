import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("A propos"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: const Text(
              '📱 Mini Réseau Social - Projet Académique\n\n'
              'Ce projet est une application mobile développée avec Flutter, ayant pour but de créer un mini réseau social interactif et moderne. '
              'Il vise à offrir une plateforme permettant aux utilisateurs de se connecter, partager du contenu, et interagir avec une communauté dynamique.\n\n'
              '🚀 Objectifs du Projet\n\n'
              '- Permettre aux utilisateurs de créer et personnaliser leur profil.\n'
              '- Offrir des fonctionnalités de publication de contenu (texte, images, etc.).\n'
              '- Faciliter les interactions via les commentaires, likes et partages.\n'
              '- Assurer une expérience utilisateur fluide grâce à une interface moderne et responsive.\n'
              '- Garantir la sécurité des données utilisateurs avec une authentification robuste.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
