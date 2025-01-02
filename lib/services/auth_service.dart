import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 ✅ 1. Inscription d'un nouvel utilisateur avec informations supplémentaires
  Future<void> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime? birthDate,
    required String? gender,
  }) async {
    try {
      // Créer l'utilisateur dans Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistrer les informations supplémentaires dans Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate?.toIso8601String(),
        'gender': gender,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Erreur Firebase Auth: ${e.message}');
    } catch (e) {
      throw Exception('Erreur générale: $e');
    }
  }

  // 🔑 ✅ 2. Connexion d'un utilisateur
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Erreur de connexion : ${e.message}');
    }
  }

  // 🚪 ✅ 3. Déconnexion d'un utilisateur
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion : $e');
    }
  }

  // 🔍 ✅ 4. Obtenir les informations de l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser?.uid).get();
        return userDoc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données utilisateur : $e');
    }
  }

  // 📧 ✅ 5. Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Erreur lors de la réinitialisation du mot de passe : ${e.message}');
    }
  }

  // 🛡️ ✅ 6. Mettre à jour le mot de passe
  Future<void> updatePassword(String newPassword) async {
    try {
      if (currentUser != null) {
        await currentUser?.updatePassword(newPassword);
      } else {
        throw Exception('Aucun utilisateur connecté.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du mot de passe : $e');
    }
  }

  // ✍️ ✅ 7. Mettre à jour les informations de l'utilisateur
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
  }) async {
    try {
      if (currentUser != null) {
        Map<String, dynamic> updatedData = {};
        if (firstName != null) updatedData['firstName'] = firstName;
        if (lastName != null) updatedData['lastName'] = lastName;
        if (birthDate != null) updatedData['birthDate'] = birthDate.toIso8601String();
        if (gender != null) updatedData['gender'] = gender;

        await _firestore.collection('users').doc(currentUser?.uid).update(updatedData);
      } else {
        throw Exception('Aucun utilisateur connecté.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil : $e');
    }
  }

  // 👀 ✅ 8. Vérifier si l'utilisateur est connecté
  bool isUserLoggedIn() {
    return currentUser != null;
  }

  // 📤 ✅ 9. Supprimer le compte utilisateur
  Future<void> deleteAccount() async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser?.uid).delete();
        await currentUser?.delete();
      } else {
        throw Exception('Aucun utilisateur connecté.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression du compte : $e');
    }
  }
}
