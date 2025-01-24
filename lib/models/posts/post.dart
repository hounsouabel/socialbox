import 'package:flutter/foundation.dart' show immutable;

@immutable
class Post {
  final String postId;
  final String posterId;
  final String content;
  final String postType;
  final String? fileUrl;
  final DateTime createdAt;
  final List<String> likes;

  const Post({
    required this.postId,
    required this.posterId,
    required this.content,
    required this.postType,
    required this.fileUrl,
    required this.createdAt,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'posterId': posterId,
      'content': content,
      'fileUrl': fileUrl,
      'datePublished': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'postType': postType,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      posterId: map['posterId'] ?? '',
      content: map['content'] ?? '',
      postType: map['postType'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['datePublished'] ?? 0,
      ),
      likes: List<String>.from(
        (map['likes'] ?? []),
      ),
    );
  }
}
