import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friends/friend_repository.dart'; // Assurez-vous d'importer le bon chemin
import '../providers/friend_provider.dart'; // Assurez-vous d'importer le bon chemin
import '../providers/get_user_info_by_id_provider.dart';

class RequestTile extends ConsumerWidget {
  final String userId;

  const RequestTile({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer les informations de l'utilisateur
    final userData = ref.watch(
        getUserInfoByIdProvider(userId)); // Assurez-vous d'avoir ce provider

    return userData.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    // Naviguer vers le profil de l'utilisateur
                    Navigator.of(context).pushNamed(
                      '/profile', // Remplacez par le nom de votre route de profil
                      arguments: userId,
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user["profil"]),
                  ),
                ),
              ),
              const SizedBox(
                  width: 15), // Espacement entre l'avatar et le texte
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["pseudo"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Accepter la demande d'ami
                              ref
                                  .read(friendProvider)
                                  .acceptFriendRequest(userId: userId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .pink, // Couleur pour le bouton "Accepter"
                            ),
                            child: const Text('Accepter', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Rejeter la demande d'ami
                              ref.read(friendProvider).removeFriendRequest(userId: userId);
                            },
                            style: ElevatedButton.styleFrom( // Fond transparent
                              side: BorderSide(
                                color: Colors.pink, // Couleur de la bordure
                                width: 2.0, // Largeur de la bordure
                              ),
                            ),
                            child: const Text(
                              'Rejeter',
                              style: TextStyle(color: Colors.pink), // Couleur du texte
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('Erreur: ${error.toString()}'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
