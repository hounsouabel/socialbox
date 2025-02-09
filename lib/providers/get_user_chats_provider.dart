import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat/chatroom.dart';



/// **Provider pour récupérer les chats de l'utilisateur connecté**
final getUserChatsProvider = StreamProvider.autoDispose<List<Chatroom>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value([]); // Retourne une liste vide si l'utilisateur n'est pas connecté

  return FirebaseFirestore.instance
      .collection('chatrooms')
      .where('members', arrayContains: userId) // Récupère tous les chats où l'utilisateur est membre
      .orderBy('lastMessageTs', descending: true) // Trie par dernier message envoyé
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Chatroom.fromMap(doc.data())).toList();
  });
});
