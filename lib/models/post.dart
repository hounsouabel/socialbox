class Post {
  final String id; // Identifiant unique du post
  final String content; // Contenu du post
  final String userId; // Identifiant de l'utilisateur
  int likes; // Nombre de likes

  Post({
    required this.id,
    required this.content,
    required this.userId,
    this.likes = 0,
  });

  // Convertir un post en JSON (pour Firebase/Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'likes': likes,
    };
  }

  // Créer un post à partir d'un JSON (Firebase/Firestore)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      userId: json['userId'],
      likes: json['likes'] ?? 0,
    );
  }

  static fromMap(Map<String, dynamic> data) {}
}
