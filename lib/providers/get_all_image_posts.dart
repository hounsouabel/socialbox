import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupe7/models/post.dart';

/// Provider pour récupérer les posts de type 'image' pour un utilisateur donné.
final getImagePostsProvider = StreamProvider.autoDispose.family<List<Post>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('postType', isEqualTo: 'image')
      .where('posterId', isEqualTo: userId)
      .orderBy('datePublished', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Post.fromMap(doc.data());
    }).toList();
  }).handleError((error) {
    print('Erreur lors de la récupération des posts : $error');
  });
});