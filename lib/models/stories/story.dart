import 'package:flutter/foundation.dart' show immutable;

@immutable
class Story {
  final String imageUrl;
  final DateTime createdAt;
  final String storyId;
  final String authorId;
   final List<String> views;

  const Story({
    required this.imageUrl,
    required this.createdAt,
    required this.storyId,
    required this.authorId,
    required this.views,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'storyId': storyId,
      'authorId': authorId,
      'views': views,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
      storyId: map['storyId'] ?? '',
      authorId: map['authorId'] ?? '',
      views: List<String>.from(
        (map['views'] ?? []),
      ),
    );
  }

  // Méthode copyWith pour modifier un champ sans toucher aux autres
  Story copyWith({
    String? storyId,
    String? authorId,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? views,
  }) {
    return Story(
      storyId: storyId ?? this.storyId,
      authorId: authorId ?? this.authorId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      views: views ?? this.views,
    );
  }
}