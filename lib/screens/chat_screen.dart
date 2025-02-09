import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:groupe7/models/chat/message.dart';
import '../providers/chat_provider.dart';
import 'user_profile.dart'; // Assurez-vous que le chemin est correct

class ConversationScreen extends ConsumerStatefulWidget {
  final String chatroomId;
  final String partnerId;

  const ConversationScreen({
    super.key,
    required this.chatroomId,
    required this.partnerId,
  });

  @override
  ConsumerState<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final chatRepo = ref.read(chatProvider);
    final String? result = await chatRepo.sendMessage(
      message: messageText,
      chatroomId: widget.chatroomId,
      receiverId: widget.partnerId,
    );
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi : $result")),
      );
    } else {
      _messageController.clear();
    }
  }

  /// Formate la date (timestamp) sous la forme HH:mm
  String _formatTimestamp(DateTime dt) {
    final String hours = dt.hour.toString().padLeft(2, '0');
    final String minutes = dt.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    final chatRepo = ref.read(chatProvider);
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.partnerId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            if (snapshot.hasError) {
              return const Text("Erreur");
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String pseudo = data['pseudo'] ?? 'Utilisateur';
            final String profileImage = data['profil'] ?? '';
            return Row(
              children: [
                // Ajout du GestureDetector sur l'image de profil
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(
                          userId: widget.partnerId,
                          isSelfProfile: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pseudo,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatRepo.getChatMessages(widget.chatroomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                final List<Message> messages = snapshot.data ?? [];

                // Marquer comme vus les messages reçus non encore vus
                final unseenMessages = messages.where((msg) =>
                msg.senderId != currentUserId && !msg.seen);
                if (unseenMessages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    for (var msg in unseenMessages) {
                      chatRepo.seenMessage(
                        chatroomId: widget.chatroomId,
                        messageId: msg.messageId,
                      );
                    }
                  });
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final Message message = messages[index];
                    bool isSentByMe = message.senderId == currentUserId;
                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 14.0),
                        decoration: BoxDecoration(
                          color: isSentByMe
                              ? Colors.pink
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                            Radius.circular(isSentByMe ? 12 : 0),
                            bottomRight:
                            Radius.circular(isSentByMe ? 0 : 12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: isSentByMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Texte du message avec ReadMoreText
                            ReadMoreText(
                              message.message,
                              trimLines: 3,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'voir plus',
                              trimExpandedText: 'voir moins',
                              style: const TextStyle(fontSize: 16),
                              moreStyle: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                              lessStyle: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Affichage de l'heure et de l'icône de validation pour les messages envoyés par moi
                            if (isSentByMe)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatTimestamp(message.timestamp),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (message.seen) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.done_all,
                                      size: 16,
                                      color: Colors.pink,
                                    ),
                                  ],
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Votre message...',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: isDarkMode ? Colors.white : Colors.pink,
                  ),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
