import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/get_user_info_by_id_provider.dart';
import 'comment_screen.dart';


class PostFooter extends ConsumerWidget {
  final String userId;
  final Post post;

  const PostFooter({super.key, required this.userId, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return userInfo.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Erreur: $error'),
      data: (userData) {
        // Vérifiez si userData contient les clés attendues
        final String profileImage = userData["profil"] ?? ''; // Valeur par défaut si null

        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //je parle de cette partie

              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(

                    userData["pseudo"],
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Text(
                     "  ${post.content}",
                      style: TextStyle(fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
                      overflow: TextOverflow.visible, // S'assure que le texte s'affiche correctement
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(10),
                          child: CommentScreen(postId: post.postId),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Voir tous les commentaires',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}