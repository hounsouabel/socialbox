import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/users/user.dart';
final getUserInfoProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("⚠️ Aucun utilisateur connecté.");
    return null;
  }

  try {
    print("🔍 Récupération des infos de l'utilisateur ${user.uid}...");

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      print("❌ L'utilisateur n'existe pas dans Firestore.");
      return null;
    }

    final data = userDoc.data();
    if (data == null) {
      print("⚠️ Aucune donnée trouvée pour cet utilisateur.");
      return null;
    }



    // Retourner un objet `UserModel` en gérant `createdAt`
    final userModel = UserModel.fromMap(data);

    print("✅ Utilisateur récupéré avec succès : ${userModel.pseudo}");

    return userModel;
  } catch (e) {
    print("❌ Erreur lors de la récupération des données utilisateur : $e");
    return null;
  }
});