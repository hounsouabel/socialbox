import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPostCountProvider = FutureProvider.family<String, String>((ref, userId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .where('posterId', isEqualTo: userId)
      .get();
  final count = querySnapshot.docs.length;
  return count.toString();
});
