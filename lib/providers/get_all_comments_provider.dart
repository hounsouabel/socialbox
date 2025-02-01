import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';

final getAllCommentsProvider = StreamProvider.autoDispose.family<Iterable<Comment>, String>((ref, String postId) {
  return FirebaseFirestore.instance
      .collection('comments')
      .where('postId', isEqualTo: postId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((commentData) => Comment.fromMap(commentData.data())).toList();
  });
});