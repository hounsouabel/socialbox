import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../screens/feed_screen.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return userInfo.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Erreur: $error'),
      data: (userData) {
        // Vérifiez si userData contient les clés attendues
        final String profileImage =
            userData["profil"] ?? ''; // Valeur par défaut si null

        return
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child:Row(

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    profileImage,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size:
                          40); // Affiche une icône d'erreur si l'image ne se charge pas
                    },
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
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_outlined,
                      size: 25, color: isDarkMode ? Colors.white : Colors.black),
                  onSelected: (String value) {
                    if (value == 'delete') {
                      // Perform delete action
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
                            Text('Supprimer', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ) ,
          );
      },
    );
  }
  Widget _buildPostDescription(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                  'assets/person2.jpg',
                  height: 25,
                  width: 25,
                  fit: BoxFit.cover,
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
                'Abel HOUNSOU: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Text(
                  'Vivre mon rêve #PHOTOSHOOT #DARK-VIBES',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  overflow: TextOverflow.visible, // S'assure que le texte s'affiche correctement
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextButton(
                  onPressed: (){
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
                  child: Text('Voir tous les commentaires', style: TextStyle(color: Colors.grey),))
          ),
        ],
      ),
    );
  }

}
