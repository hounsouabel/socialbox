import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final suggestedUsersProvider = StreamProvider<List<String>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return const Stream.empty();

  final currentUserId = currentUser.uid;

  return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
    final allUsers = snapshot.docs.map((doc) => doc.id).toList();

    // Vérifier si l'utilisateur actuel existe dans Firestore
    final currentUserDocList = snapshot.docs.where((doc) => doc.id == currentUserId).toList();

    if (currentUserDocList.isEmpty) {
      return allUsers; // Si le document utilisateur n'existe pas, retourner tous les utilisateurs
    }

    final currentUserDoc = currentUserDocList.first;
    final userData = currentUserDoc.data();

    final friends = (userData['friends'] as List<dynamic>?) ?? [];
    final sentRequests = (userData['sentRequests'] as List<dynamic>?) ?? [];
    final receivedRequests = (userData['receivedRequests'] as List<dynamic>?) ?? [];

    // Filtrer les utilisateurs non associés
    return allUsers.where((userId) =>
    userId != currentUserId &&
        !friends.contains(userId) &&
        !sentRequests.contains(userId) &&
        !receivedRequests.contains(userId)
    ).toList();
  });
});
