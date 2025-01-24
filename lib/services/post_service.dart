import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe7/models/post.dart';
import 'package:uuid/uuid.dart';


class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un post
  Future<void> addPost(String content, String userId) async {
    final postId = const Uuid().v4(); // Génère un ID unique
    final post = Post(id: postId, content: content, userId: userId);

    await _firestore.collection('posts').doc(postId).set(post.toJson());
  }

  // Récupérer tous les posts
  Stream<List<Post>> getPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    });
  }

  // Ajouter un like à un post
  Future<void> likePost(String postId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    await postRef.update({'likes': FieldValue.increment(1)});
  }
}
