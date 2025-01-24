import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe7/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllVideosProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection("posts")
      .where("postType", isEqualTo: 'video')
      .orderBy("datePublished", descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (postData) => Post.fromMap(
        postData.data(),
      ),
    ).cast<Post>();
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});