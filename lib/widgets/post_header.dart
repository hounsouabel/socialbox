import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupe7/screens/use_profile.dart';
import '../providers/general_provider.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../screens/full_image_screen.dart';
import 'comment_screen.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({super.key, required this.userId, required this.postId});

  final String userId;
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    // Récupérer l'ID de l'utilisateur connecté
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return userInfo.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Erreur: $error'),
      data: (userData) {
        final String profileImage = userData["profil"] ?? '';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    profileImage,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userData["pseudo"],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.offline_pin, color: Colors.blue, size: 15),
              // Affichage de l'option Supprimer uniquement si l'utilisateur connecté est le propriétaire du post.
              if (currentUserId == userId)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    size: 25,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onSelected: (String value) {
                    if (value == 'delete') {
                      ref.read(globalProvider).deletePost(postId: postId).then((result) {
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur : $result")),
                          );
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}