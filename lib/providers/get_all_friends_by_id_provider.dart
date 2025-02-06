import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendsProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, userId) async {
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final friends = (userDoc.data()?['friends'] as List?)?.cast<String>() ?? [];
  return friends;
});