import 'package:flutter/foundation.dart' show immutable;

@immutable
class Comment {
  final String commentId;
  final String authorId;
  final String postId;
  final String text;
  final DateTime createdAt;
  final List<String> likes;

  const Comment({
    required this.commentId,
    required this.authorId,
    required this.postId,
    required this.text,
    required this.createdAt,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'authorId': authorId,
      'postId': postId,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] ?? '',
      authorId: map['authorId'] ?? '',
      postId: map['postId'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
      likes: List<String>.from(
        (map['likes'] ?? []),
      ),
    );
  }
}