import 'package:flutter/foundation.dart' show immutable;

@immutable
class Post {
  final String postId;
  final String posterId;
  final String content;
  final String postType;
  final String fileUrl;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> favorites;

  const Post( {
    required this.postId,
    required this.posterId,
    required this.content,
    required this.postType,
    required this.fileUrl,
    required this.createdAt,
    required this.likes,
    required this.favorites
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'poster_id': posterId,
      'content': content,
      'file_url': fileUrl,
      'datePublished': createdAt.millisecondsSinceEpoch, // Correction ici
      'likes': likes,
      'postType': postType,
      'favorites':favorites
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      posterId: map['posterId'] ?? '',
      content: map['content'] ?? '',
      postType: map['postType'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['datePublished'] ?? 0), // Correction ici
      likes: List<String>.from(map['likes'] ?? []),
      favorites: List<String>.from(map['favorites'] ?? []),
    );
  }
}
