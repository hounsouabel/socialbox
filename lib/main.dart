import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupe7/home.dart';
import 'package:groupe7/screens/home_page.dart';
import 'package:groupe7/screens/profile_image_selection.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  // Initialisation de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
// Configuration de Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Active la persistance locale
    sslEnabled: true, // Assure que SSL est activé
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Vérifie si des informations de connexion sont enregistrées et gère la navigation
  Future<Widget> _getInitialPage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      final password = prefs.getString('user_password');

      // Vérifie les informations de connexion
      if (email != null && password != null) {
        final user = FirebaseAuth.instance.currentUser;

        // Vérifie si l'utilisateur est connecté
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          // Redirige vers la sélection de l'image de profil si c'est la première connexion
          if (userDoc.exists && userDoc.data()?['firstLogin'] == true) {
            return ProfileImageSelection(userId: user.uid);
          }

          // Redirige vers la page d'accueil normale
          return const ChatterBox();
        }
      }

      // Redirige vers la page de connexion si aucune information n'est enregistrée
      return const MyHomePage();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation : $e');
      return const MyHomePage(); // Retourne la page de connexion en cas d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        final Widget initialPage = snapshot.connectionState == ConnectionState.waiting
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : snapshot.data ?? const MyHomePage();

        return MaterialApp(
          title: 'Social Hub',
          debugShowCheckedModeBanner: false,
          // Thème clair
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
            ),
          ),
          // Thème sombre
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
            scaffoldBackgroundColor: Colors.black,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
            ),
          ),
          themeMode: ThemeMode.system,
          home: initialPage,
        );
      },
    );
  }
}
