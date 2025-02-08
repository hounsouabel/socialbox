/*import 'package:flutter/material.dart';
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
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/get_user_info_by_id_provider.dart';
import '../screens/user_profile.dart';

class RequestTile extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userImage;
  final bool isSentRequest;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;

  const RequestTile({
    super.key,
    required this.userId,
    required this.userName,
    this.userImage,
    this.isSentRequest = false,
    this.onAccept,
    this.onReject,
    this.onCancel,
  });

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return ListTile(
      leading: GestureDetector(
        onTap: () => _navigateToProfile(context),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: _getProfileImage(),
          onBackgroundImageError: (_, __) => const Icon(Icons.error),
          child: widget.userImage == null ? const Icon(Icons.person) : null,
        ),
      ),
      title: Text(
        widget.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.isSentRequest ? 'Demande envoyée' : 'Demande reçue',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: _buildActionButtons(),
    );
  }

  ImageProvider? _getProfileImage() {
    if (widget.userImage?.isNotEmpty ?? false) {
      return NetworkImage(widget.userImage!);
    }
    return const AssetImage('assets/default_profile.png');
  }

  Widget _buildActionButtons() {
    if (_isProcessing) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return widget.isSentRequest
        ? IconButton(
      icon: const Icon(Icons.cancel, color: Colors.red),
      onPressed: () => _handleAction(widget.onCancel),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () => _handleAction(widget.onAccept),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () => _handleAction(widget.onReject),
        ),
      ],
    );
  }

  void _handleAction(VoidCallback? callback) async {
    if (callback == null || _isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      callback();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(
          userId: widget.userId,
          isSelfProfile: widget.userId == FirebaseAuth.instance.currentUser?.uid,
        ),
      ),
    );
  }
}