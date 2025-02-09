import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/screens/chatsScreen.dart';
import 'package:groupe7/screens/update_profile.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friends/friend_repository.dart';
import '../providers/get_all_friends_by_id_provider.dart';
import '../providers/get_all_image_posts.dart';
import '../providers/get_all_video_posts_by_userId.dart';
import '../providers/get_posts_count_by_id.dart';
import '../providers/get_user_info_by_id_provider.dart';

import '../widgets/profile_images_view.dart';
import '../widgets/video_thumbnail_widget.dart';
import 'full_screen_video.dart';
import 'image_plein_ecran.dart';

class UserProfile extends ConsumerStatefulWidget {
  final String userId;
  final bool isSelfProfile;

  const UserProfile({
    super.key,
    required this.userId,
    required this.isSelfProfile,
  });

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  final FriendRepository _friendRepository = FriendRepository();
  bool _isFollowing = false; // État pour suivre ou non
  late VideoPlayerController _controller;
  bool _isFriend = false;
  String countFriends = "";
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/sample_video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _checkIfFollowing();
    setState(() {});
  }

  Future<void> _sendFriendRequest() async {
    String? result =
    await _friendRepository.sendFriendRequest(userId: widget.userId);
    if (result == null) {
      setState(() {
        _isFollowing = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Demande d'amitié envoyée")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur: $result")));
    }
  }

  Future<void> _checkIfFollowing() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data() ?? {};
      final sentRequests = List<String>.from(data['sentRequests'] ?? []);
      final friends = List<String>.from(data['friends'] ?? []);

      setState(() {
        _isFriend = friends.contains(widget.userId);
        _isFollowing = sentRequests.contains(widget.userId);
      });
    }
  }

  ///Récupération de l'url profil des amis
  Future<String> _getProfilePicUrl(String userId) async {
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data()?['profil'] ??
        "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png"; // URL par défaut
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    final userInfoAsyncValue = ref.watch(getUserInfoByIdProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(actions: []),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: userInfoAsyncValue.when(
        data: (userData) {
          countFriends = (userData['friends']?.length ?? 0).toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageUrl: userData['profil']!,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userData[
                                'profil'] ??
                                    'https://img.icons8.com/?size=100&id=98957&format=png&color=000000'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${userData['lastName'] ?? ''} ${userData['firstName'] ?? ''}"
                                        .trim()
                                        .isEmpty
                                        ? 'Nom inconnu'
                                        : "${userData['lastName']} ${userData['firstName']}",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "@" + userData['pseudo'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    !widget.isSelfProfile
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE4395F),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: _isFollowing || _isFriend
                          ? null
                          : _sendFriendRequest,
                      child: Row(
                        children: [
                          if (!_isFollowing && !_isFriend)
                            const Icon(Icons.person_add_alt_1,
                                color: Colors.white),
                          Text(
                            _isFriend
                                ? "Amis"
                                : _isFollowing
                                ? "Demande envoyée"
                                : " Ajouter ami(e)",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                        : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE4395F),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfile()),
                          );
                        },
                        child: Text(
                          "Modifier votre profil",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(width: 7),
                    !widget.isSelfProfile
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatsScreen()),
                        );
                      },
                      child: const Text(
                        "Message",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.pink,
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
                const Divider(color: Colors.transparent),
                Container(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:
                        _buildInfoColumn("AMIS", countFriends, textColor),
                      ),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final postCountAsync =
                            ref.watch(userPostCountProvider(widget.userId));
                            return postCountAsync.when(
                              data: (count) => _buildInfoColumn(
                                  "PUBLICATIONS", count.toString(), textColor),
                              loading: () => _buildInfoColumn(
                                  "PUBLICATIONS", "0", textColor),
                              error: (error, stack) => _buildInfoColumn(
                                  "PUBLICATIONS", "0", textColor),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Amis",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 90,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final friendsAsync =
                      ref.watch(friendsProvider(widget.userId));

                      return friendsAsync.when(
                        data: (friends) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: friends.length,
                            itemBuilder: (BuildContext context, int index) {
                              final friendId = friends[index];
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                          userId: friendId,
                                          isSelfProfile:
                                          currentUserId == friendId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 56,
                                        width: 56,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          child: FutureBuilder<String>(
                                            future: _getProfilePicUrl(friendId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Image.network(
                                                  "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png",
                                                  fit: BoxFit.contain,
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
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                        const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Erreur: $error')),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                ImagesView(userId: widget.userId),
                const SizedBox(height: 8),
                VideoSection(userId: widget.userId),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String count, Color textColor) {
    return Container(
      width: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoSection extends ConsumerWidget {
  final dynamic userId;

  const VideoSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final videoPostsAsync = ref.watch(videoPostsProvider(userId));

    return videoPostsAsync.when(
      data: (videos) {
        if (videos.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vidéos",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoPost = videos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 160,
                      width: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenVideoScreen(
                                  videoUrl: videoPost.fileUrl,
                                  post: videoPost,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              VideoThumbnailWidget(videoUrl: videoPost.fileUrl),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Icon(
                                  Icons.movie_creation_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Erreur: $error")),
    );
  }
}

class ImagesView extends ConsumerWidget {
  final dynamic userId;

  const ImagesView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesAsync = ref.watch(getImagePostsProvider(userId));

    return imagesAsync.when(
      data: (images) {
        if (images.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Photos",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 160,
                      width: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(
                                  imageUrl: image.fileUrl,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                image.fileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildErrorIcon(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Erreur: $error")),
    );
  }

  Widget _buildErrorIcon() {
    return const Icon(Icons.error, color: Colors.red, size: 40);
  }
}