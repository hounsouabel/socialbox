import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout pour récupérer l'utilisateur actuel
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../screens/feed_screen.dart';
import '../widgets/post_footer.dart';
import '../widgets/post_header.dart';

class PostWidget extends ConsumerWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Vérifie si `posterId` est valide
    if (post.posterId.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('ID de l\'afficheur manquant'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(userId: post.posterId),
          const SizedBox(height: 8),
          _buildPostImage(context),
          _buildPostActions(context, ref),
          PostFooter(userId: post.posterId, post: post),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  /// Widget pour afficher l'image ou la vidéo du post
  Widget _buildPostImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        child: post.fileUrl != null && post.fileUrl!.isNotEmpty
            ? Image.network(
          post.fileUrl!,
          height: 300,
          fit: BoxFit.cover,
        )
            : const SizedBox(), // Ne rien afficher si `fileUrl` est null ou vide
      ),
    );
  }

  /// Widget pour afficher les boutons d'action sous le post (Like, Comment, Share)
  Widget _buildPostActions(BuildContext context, WidgetRef ref) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Récupérer l'ID de l'utilisateur connecté
    final bool isLiked = post.likes.contains(currentUserId); // Vérifier si l'utilisateur a liké le post

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Bouton Like
          LikeButton(
            size: 25,
            isLiked: isLiked, // Vérification correcte
            onTap: (isLiked) async {
              await ref.read(postsProvider).likeDislikePost(
                postId: post.postId,
                likes: post.likes,
              );
              return !isLiked;
            },
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                size: 25,
                color: isLiked ? Colors.red : Colors.black, // Corrigé : couleur rouge SEULEMENT si l'utilisateur a liké
              );
            },
            likeCount: post.likes.length,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                count == 0 ? 'Like' : text,
                style: TextStyle(
                  color: isLiked ? Colors.red : Colors.black,
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // Bouton Commentaire
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    child: TestMe(), // Remplace par ton `TestMe()`
                  );
                },
              );
            },
            icon: const Icon(Icons.mode_comment_outlined, size: 25),
          ),
          const SizedBox(width: 8),

          // Bouton Partage
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.near_me_outlined, size: 25),
          ),

          const Spacer(),

          // Bouton Enregistrer
          LikeButton(
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.bookmark,
                size: 25,
                color: isLiked ? Colors.yellowAccent : Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}
