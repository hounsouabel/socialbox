import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:groupe7/providers/chat_provider.dart';

import '../models/chat/chatroom.dart';
import '../providers/get_all_friends_by_id_provider.dart';
import '../widgets/chat_list_tile.dart';
import 'chat_screen.dart'; // Si vous souhaitez naviguer vers le profil

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  /// Récupère l'URL de l'image de profil de l'ami depuis Firestore.
  Future<String> _getProfilePicUrl(String friendId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .get();
    final data = doc.data();
    if (data != null &&
        data['profil'] is String &&
        data['profil'].isNotEmpty) {
      return data['profil'] as String;
    }
    return "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png";
  }

  /// Vérifie si l'ami est en ligne.
  Future<bool> _isFriendOnline(String friendId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .get();
    final data = doc.data();
    if (data != null && data['isOnline'] != null) {
      return data['isOnline'] as bool;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'UID de l'utilisateur connecté
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversations"),
        backgroundColor: const Color(0xFFD11E7C),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section "Amis"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Amis",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Container(
            height: 90,
            child: Consumer(
              builder: (context, ref, _) {
                final friendsAsync = ref.watch(friendsProvider(currentUserId));
                return friendsAsync.when(
                  data: (friends) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String friendId = friends[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () async {
                              // Crée ou récupère le chatroom entre l'utilisateur et cet ami
                              final chatRepo = ref.read(chatProvider);
                              final String chatroomId = await chatRepo
                                  .createChatroom(userId: friendId);
                              // Navigue vers l'écran de conversation
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConversationScreen(
                                    chatroomId: chatroomId,
                                    partnerId: friendId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 56,
                                      width: 56,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: FutureBuilder<String>(
                                          future: _getProfilePicUrl(friendId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2));
                                            } else if (snapshot.hasError) {
                                              return Image.network(
                                                "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png",
                                                fit: BoxFit.cover,
                                              );
                                            } else {
                                              return Image.network(
                                                snapshot.data ??
                                                    "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png",
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    // Indicateur de présence en ligne
                                    FutureBuilder<bool>(
                                      future: _isFriendOnline(friendId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }
                                        if (snapshot.hasData &&
                                            snapshot.data == true) {
                                          return Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                                // Vous pouvez ajouter le nom de l'ami en dessous si besoin
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Erreur: $error')),
                );
              },
            ),
          ),
          const Divider(),
          // Ici vous pouvez ajouter la liste des conversations existantes (chatrooms) si vous le souhaitez.
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
              // Récupère les chatrooms où l'utilisateur connecté est membre.
                  .where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid)
              // Trie par dernier message (le plus récent en premier).
                  .orderBy('lastMessageTs', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucune conversation'));
                }

                // Transformation des documents Firestore en objets Chatroom.
                final List<Chatroom> chatrooms = snapshot.data!.docs
                    .map((doc) => Chatroom.fromMap(
                    doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  itemCount: chatrooms.length,
                  itemBuilder: (context, index) {
                    final chatroom = chatrooms[index];
                    return ChatListTile(
                      chatroom: chatroom,
                      currentUserId:
                      FirebaseAuth.instance.currentUser!.uid,
                    );
                  },
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
