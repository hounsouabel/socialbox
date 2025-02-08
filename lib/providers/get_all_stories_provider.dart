import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/stories/story.dart';
import 'get_user_info_provider.dart';

final getAllStoriesProvider = StreamProvider.autoDispose<Iterable<Story>>((ref) {
  final controller = StreamController<Iterable<Story>>();
  final userDataAsync = ref.watch(getUserInfoProvider);

  userDataAsync.whenData((user) {
    if (user == null || user.friends.isEmpty) {
      controller.sink.add([]); // Aucun ami, donc aucune story à afficher
      print("Aucun ami trouvé");
      return;
    }

    final myFriends = [
      FirebaseAuth.instance.currentUser !.uid,
      ...user.friends, // Assurez-vous que c'est une liste valide
    ];
    print("Amis trouvés : $myFriends");

    // Obtenir le timestamp d'hier en millisecondes
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;

    final sub = FirebaseFirestore.instance
        .collection('stories')
        .where('createdAt', isGreaterThan: yesterday) // Comparer avec un entier
        .snapshots()
        .listen((snapshot) {
      final stories = snapshot.docs
          .map((doc) => Story.fromMap(doc.data()))
          .where((story) => myFriends.contains(story.authorId))
          .toList();

      controller.sink.add(stories);
    });

    ref.onDispose(() {
      controller.close();
      sub.cancel();
    });
  });

  return controller.stream;
});