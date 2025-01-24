import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe7/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection('posts') // Remplacement de FirebaseCollectionNames.posts
      .orderBy('datePublished', descending: true) // Remplacement de FirebaseFieldNames.datePublished
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (postData) => Post.fromMap(
        postData.data(),
      ),
    ).cast<Post>(); // Conversion  en Iterable<Post>

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});