/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat/message.dart';
import '../providers/get_all_messages_provider.dart';
import '../providers/chat_provider.dart';


class MessagesList extends ConsumerWidget {
  final String chatroomId;

  const MessagesList({super.key, required this.chatroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(getAllMessagesProvider(chatroomId));
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return messagesList.when(
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(
            child: Text(
              "Aucun message pour le moment",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final messagesList = messages.toList(); // ✅ Conversion en List<Message>

        return ListView.builder(
          reverse: true, // Affiche les derniers messages en bas
          itemCount: messagesList.length,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          itemBuilder: (context, index) {
            final Message message = messagesList[index]; // ✅ Utilisation correcte de []

            final bool isMyMessage = message.senderId == myUid;

            // Marquer le message comme "vu" s'il ne vient pas de l'utilisateur
            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                chatroomId: chatroomId,
                messageId: message.messageId,
              );
            }

            return Align(
              alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMyMessage ? const Color(0xFFD11E7C) : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isMyMessage ? const Radius.circular(12) : Radius.zero,
                    bottomRight: isMyMessage ? Radius.zero : const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (message.messageType == "text") ...[
                      Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: isMyMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ] else if (message.messageType == "image") ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.message,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ] else if (message.messageType == "video") ...[
                      GestureDetector(
                        onTap: () {
                          // TODO: Ouvrir un lecteur vidéo
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: isMyMessage ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            "Erreur: ${error.toString()}",
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// **Formatage du timestamp**
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} min";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} h";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }
}
*/