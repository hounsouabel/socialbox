import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:groupe7/models/chat/message.dart';
import '../providers/chat_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final chatRepo = ref.read(chatProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Conversation")),
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
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final Message message = messages[index];
                    bool isSentByMe = message.senderId ==
                        FirebaseAuth.instance.currentUser!.uid;
                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isSentByMe
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ReadMoreText(
                          message.message,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'voir plus',
                          trimExpandedText: 'voir moins',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Votre message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
