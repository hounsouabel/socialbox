/*import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';

import 'package:image_picker/image_picker.dart';

import '../widgets/message_list_widget.dart';



class ChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  String? chatroomId;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ref.watch(chatProvider).createChatroom(userId: widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        chatroomId = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFD11E7C),
            foregroundColor: Colors.white,
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                ),
                const SizedBox(width: 10),
                Text(widget.userName),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(child: MessagesList(chatroomId: chatroomId!)),
              _buildMessageInput(),
            ],
          ),
        );
      },
    );
  }

  /// **Barre d'envoi de message**
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          _buildMediaButton(Icons.image, 'image'),
          _buildMediaButton(Icons.video_library, 'video'),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Écrire un message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFD11E7C)),
            onPressed: _sendTextMessage,
          ),
        ],
      ),
    );
  }

  /// **Boutons d'envoi de médias (images/vidéos)**
  Widget _buildMediaButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey),
      onPressed: () async => await _sendMediaMessage(type),
    );
  }

  /// **Envoi d'un message texte**
  Future<void> _sendTextMessage() async {
    if (_messageController.text.trim().isEmpty || chatroomId == null) return;

    await ref.read(chatProvider).sendMessage(
      message: _messageController.text.trim(),
      chatroomId: chatroomId!,
      receiverId: widget.userId,
    );

    _messageController.clear();
  }

  /// **Envoi d'un fichier (image/vidéo) avec Cloudinary**
  Future<void> _sendMediaMessage(String mediaType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null || chatroomId == null) return;

    final cloudinary = CloudinaryPublic('ton_cloud_name', 'preset_nom', cache: false);

    try {
      final CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path, resourceType: mediaType == "image" ? CloudinaryResourceType.Image : CloudinaryResourceType.Video),
      );

      await ref.read(chatProvider).sendFileMessage(
        fileUrl: response.secureUrl,
        chatroomId: chatroomId!,
        receiverId: widget.userId,
        messageType: mediaType,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur d'upload : $e")));
    }
  }
}*/
