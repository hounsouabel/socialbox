import 'package:flutter/foundation.dart' show immutable;

@immutable
class Chatroom {
  final String chatroomId;
  final String lastMessage;
  final DateTime lastMessageTs;
  final List<String> members;
  final DateTime createdAt;

  const Chatroom({
    required this.chatroomId,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomId': chatroomId,
      'lastMessage': lastMessage,
      'lastMessageTs': lastMessageTs.millisecondsSinceEpoch,
      'members': members,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Chatroom.fromMap(Map<String, dynamic> map) {
    return Chatroom(
      chatroomId: map['chatroomId'] as String,
      lastMessage: map['lastMessage'] as String,
      lastMessageTs: DateTime.fromMillisecondsSinceEpoch(
        map['lastMessageTs'] as int,
      ),
      members: List<String>.from(
        (map['members'] as List),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int,
      ),
    );
  }
}