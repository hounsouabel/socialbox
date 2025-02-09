import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../providers/general_provider.dart';
import '../utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final userInfoAsync = ref.watch(getUserInfoByIdProvider(comment.authorId));

    final bool isLiked = comment.likes.contains(currentUserId);

    return userInfoAsync.when(
      data: (userData) {
        final String pseudo = userData['pseudo'] ?? 'Utilisateur inconnu';
        final String profileUrl = userData['profil'] ?? '';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
            child: profileUrl.isEmpty ? const Icon(Icons.person_outline) : null,
          ),
          title: Text(
            pseudo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(comment.text),
          trailing: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatTimeAgo(comment.createdAt),
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                      onPressed: () async {
                        final result = await ref.read(globalProvider).likeDislikeComment(
                          commentId: comment.commentId,
                          likes: comment.likes,
                        );
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur : $result")),
                          );
                        }
                      },
                    ),
                    Text(
                      '${comment.likes.length}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const ListTile(
        leading: CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text("Chargement..."),
      ),
      error: (e, stack) => const ListTile(
        leading: CircleAvatar(child: Icon(Icons.error)),
        title: Text("Erreur"),
      ),
    );
  }
}
