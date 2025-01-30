import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe7/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 **Provider pour récupérer tous les posts de Firestore**
final getAllPostsProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('datePublished', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return Post.fromMap(doc.data());
      } catch (e) {
        print('Erreur lors de la conversion du document : $e');
        return null; // Ou gérer l'erreur comme vous le souhaitez
      }
    }).where((post) => post != null).cast<Post>().toList();
  })
      .handleError((error) {
    print('Erreur lors de la récupération des posts : $error');
  });
});