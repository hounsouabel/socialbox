import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

// Provider pour gérer l'état de la liste des posts avec un StateNotifier
final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier();
});

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super([]);

  /// Récupère les posts depuis Firestore et met à jour l'état.
  Future<void> fetchPosts() async {
    try {
      // Récupère les documents de la collection "posts" triés par datePublished décroissante
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .get();

      // Convertit chaque document en instance de Post
      final posts = snapshot.docs.map((doc) {
        try {
          // On suppose que la classe Post possède une méthode fromMap pour la conversion
          return Post.fromMap(doc.data());
        } catch (e) {
          print('Erreur lors de la conversion du document ${doc.id} : $e');
          return null;
        }
      }).where((post) => post != null) // Filtre les éventuels null
          .cast<Post>()
          .toList();

      // Met à jour l'état avec la liste de posts récupérée
      state = posts;
    } catch (error) {
      print('Erreur lors de la récupération des posts : $error');
    }
  }

  /// Optionnel : Fournit un stream des posts pour une mise à jour continue de l'interface.
  Stream<List<Post>> postsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Post.fromMap(doc.data());
        } catch (e) {
          print('Erreur lors de la conversion du document ${doc.id} : $e');
          return null;
        }
      }).where((post) => post != null).cast<Post>().toList();
    }).handleError((error) {
      print('Erreur lors de la récupération des posts par stream : $error');
    });
  }
}
