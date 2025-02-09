import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat/message.dart';

Stream<List<Message>> getChatMessages(String chatroomId) {
  return FirebaseFirestore.instance
      .collection('chatrooms')
      .doc(chatroomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Message.fromMap(doc.data()))
      .toList());
}
