import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

import 'chatroom.dart';
import 'message.dart';

@immutable
class ChatRepository {
  final _myUid = FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Cloudinary Config
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'ton_cloud_name', // Remplace par ton Cloud Name
    'preset_nom', // Remplace par ton Upload Preset
    cache: false,
  );

  /// **Créer un chatroom si inexistant**
  Future<String> createChatroom({required String userId}) async {
    try {
      CollectionReference chatrooms = FirebaseFirestore.instance.collection('chatrooms');

      // 🔹 Trier les IDs pour assurer unicité du chat
      final sortedMembers = [_myUid, userId]..sort((a, b) => a.compareTo(b));

      // 🔹 Vérifier si un chatroom existe déjà
      QuerySnapshot existingChatrooms = await chatrooms
          .where('members', isEqualTo: sortedMembers)
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        Chatroom chatroom = Chatroom(
          chatroomId: chatroomId,
          lastMessage: '',
          lastMessageTs: now,
          members: sortedMembers,
          createdAt: now,
        );

        await chatrooms.doc(chatroomId).set(chatroom.toMap());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  /// **Envoyer un message texte**
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: _myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference chatroomRef = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatroomId);

      await chatroomRef
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      await chatroomRef.update({
        'lastMessage': message,
        'lastMessageTs': now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// **Envoyer un fichier (image/vidéo)**
  Future<String?> sendFileMessage({
    required String fileUrl, // Utilisation de l'URL directe
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: fileUrl, // 🔹 Stockage de l'URL Cloudinary
        messageId: messageId,
        senderId: _myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference chatroomRef = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatroomId);

      await chatroomRef
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      await chatroomRef.update({
        'lastMessage': 'sent a $messageType',
        'lastMessageTs': now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// **Marquer un message comme "vu"**
  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatroomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'seen': true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Récupère les messages d'un chatroom en temps réel
  Stream<List<Message>> getChatMessages(String chatroomId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        Message.fromMap(doc.data()))
        .toList());
  }
}
