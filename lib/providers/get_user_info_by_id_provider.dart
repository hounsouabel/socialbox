import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserInfoByIdProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) async {
  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();

  if (!userDoc.exists || userDoc.data() == null) {
    throw Exception("Utilisateur non trouvé");
  }

  return userDoc.data()!;
});