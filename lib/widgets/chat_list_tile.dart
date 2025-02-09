import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/models/chat/chatroom.dart';
import '../screens/chat_screen.dart'; // Assurez-vous que ConversationScreen est importé correctement

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
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const ListTile(
            title: Text('Chargement...'),
          );
        }
        if (userSnapshot.hasError) {
          return const ListTile(
            title: Text('Erreur de chargement'),
          );
        }
        final data = userSnapshot.data!.data() as Map<String, dynamic>;
        final String partnerName = data['pseudo'] ?? 'Utilisateur';
        final String partnerImage = data['profil'] ?? '';

        // Récupération du dernier message depuis la sous-collection 'messages'
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(chatroom.chatroomId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get(),
          builder: (context, lastMsgSnapshot) {
            bool isUnread = false;
            if (lastMsgSnapshot.hasData && lastMsgSnapshot.data!.docs.isNotEmpty) {
              final lastMsgDoc = lastMsgSnapshot.data!.docs.first;
              final lastMsgData = lastMsgDoc.data() as Map<String, dynamic>;
              // Si le dernier message est envoyé par le partenaire et n'est pas vu
              if (lastMsgData['senderId'] == partnerId && (lastMsgData['seen'] == null || lastMsgData['seen'] == false)) {
                isUnread = true;
              }
            }
            return ListTile(
              leading: partnerImage.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(partnerImage))
                  : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                partnerName,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              // Affiche la première ligne du dernier message
              subtitle: Text(
                chatroom.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTimestamp(chatroom.lastMessageTs),
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  if (isUnread) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
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
      },
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
