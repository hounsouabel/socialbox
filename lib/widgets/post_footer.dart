import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../screens/feed_screen.dart';

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
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      profileImage, // Utilisez profileImage ici
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 25); // Affiche une icône d'erreur si l'image ne se charge pas
                      },
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: ' Aimé par ',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          TextSpan(
                            text: 'Viral ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          TextSpan(
                            text: 'et ',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          TextSpan(
                            text: '98 autres personnes',
                            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData["pseudo"],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                     " ${post.content}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                      overflow: TextOverflow.visible, // S'assure que le texte s'affiche correctement
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(10),
                          child: TestMe(),
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