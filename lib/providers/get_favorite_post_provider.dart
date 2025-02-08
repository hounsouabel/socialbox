import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';

final getFavoritePostsProvider = StreamProvider<List<Post>>((ref) {
  final userId = FirebaseAuth.instance.currentUser ?.uid;

  if (userId == null) {
    return Stream.value([]); // Retourne une liste vide si l'utilisateur n'est pas connecté
  }

  return FirebaseFirestore.instance
      .collection('posts')
      .where('favorites', arrayContains: userId) // Filtrer les posts où l'utilisateur est dans la liste des favoris
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Post.fromMap(doc.data());
    }).toList();
  });
});