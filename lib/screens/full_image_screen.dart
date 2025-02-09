import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/get_user_info_by_id_provider.dart';


import '../widgets/post_footer.dart';

class FullScreenImageScreen extends ConsumerWidget {
  final String imageUrl;
  final Post post;

  const FullScreenImageScreen({
    super.key,
    required this.imageUrl,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupération des infos de l'utilisateur grâce à son id
    final userInfo = ref.watch(getUserInfoByIdProvider(post.posterId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
          children: [

            Expanded(
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Affichage de la description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: userInfo.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(
                  'Erreur: $error',
                  style: const TextStyle(color: Colors.white),
                ),
                data: (userData) {
                  return ExpandableRichText(
                    pseudo: userData["pseudo"]+"  ",
                    content: post.content,
                    trimLines: 3,
                    pseudoStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:Colors.white,
                    ),
                    contentStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color:Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
      ),
    );
  }
}
