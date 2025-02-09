import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/models/chat/chatroom.dart';
import '../screens/chat_screen.dart';

class ChatListTile extends StatelessWidget {
  final Chatroom chatroom;
  final String currentUserId;

  const ChatListTile({
    super.key,
    required this.chatroom,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // Pour un chat tête-à-tête, le partenaire est l'autre membre.
    final String partnerId = chatroom.members.firstWhere(
          (id) => id != currentUserId,
      orElse: () => currentUserId,
    );

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(partnerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text('Chargement...'),
          );
        }
        if (snapshot.hasError) {
          return const ListTile(
            title: Text('Erreur de chargement'),
          );
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final String partnerName = data['pseudo'] ?? 'Utilisateur';
        final String partnerImage = data['profil'] ?? '';

        return ListTile(
          leading: partnerImage.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(partnerImage))
              : const CircleAvatar(child: Icon(Icons.person)),
          title: Text(partnerName),
          // Affiche la première ligne du dernier message avec un texte tronqué.
          subtitle: Text(
            chatroom.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Tronque le texte avec des points de suspension
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: Text(_formatTimestamp(chatroom.lastMessageTs)),
          onTap: () {
            // Ouvre l'écran de conversation en passant chatroomId et partnerId.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConversationScreen(
                  chatroomId: chatroom.chatroomId,
                  partnerId: partnerId,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}