import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';

final videoPostsProvider = StreamProvider.family<List<Post>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('postType', isEqualTo: 'video')
      .where('posterId', isEqualTo: userId)
      .orderBy('datePublished', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Post.fromMap(doc.data()))
      .toList());
});
