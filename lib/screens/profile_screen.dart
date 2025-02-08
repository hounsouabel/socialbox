import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupe7/screens/bio.dart';
import 'package:groupe7/screens/profile_image_selection.dart';
import 'package:groupe7/screens/tabs/feed_view.dart';
import 'package:groupe7/screens/tabs/reels_view.dart';
import 'package:groupe7/screens/tabs/tagged_view.dart';
import 'package:groupe7/screens/update_profile.dart';
import 'package:groupe7/screens/user_profile.dart';
import '../providers/friend_provider.dart';
import '../providers/get_posts_count_by_id.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../services/auth_service.dart';
import 'image_plein_ecran.dart';

// Provider pour les suggestions d'utilisateurs
final suggestedUsersProvider = StreamProvider<List<String>>((ref) {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('users').snapshots().map((snapshot) {
    final allUsers = snapshot.docs.map((doc) => doc.id).toList();

    final currentUserDoc =
        snapshot.docs.firstWhere((doc) => doc.id == currentUserId);
    final friends = List<String>.from(currentUserDoc['friends'] ?? []);
    final sentRequests =
        List<String>.from(currentUserDoc['sentRequests'] ?? []);
    final receivedRequests =
        List<String>.from(currentUserDoc['receivedRequests'] ?? []);

    return allUsers.where((userId) {
      return userId != currentUserId &&
          !friends.contains(userId) &&
          !sentRequests.contains(userId) &&
          !receivedRequests.contains(userId);
    }).toList();
  });
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _userName = 'Utilisateur';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loadUserData() async {
    AuthService authService = AuthService();

    try {
      var userData = await authService.getUserData();

      if (userData != null) {
        setState(() {
          _userName = '${userData['firstName']} ${userData['lastName']}';
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune donnée utilisateur trouvée.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  final List<Widget> tabs = [
    const Tab(icon: Icon(Icons.image, color: Colors.grey)),
    const Tab(icon: Icon(Icons.video_collection, color: Colors.grey)),
    const Tab(icon: Icon(Icons.bookmark, color: Colors.grey)),
  ];

  final List<Widget> tabBarViews = [
    FeedView(userId: FirebaseAuth.instance.currentUser!.uid),
    VideoView(userId: FirebaseAuth.instance.currentUser!.uid),
    const TaggedView(),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userId = user?.uid;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildErrorWidget('Erreur de chargement');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final hasBio = (userData['bio'] as String?)?.isNotEmpty ?? false;

            return ListView(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Stack(
                        children: [
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
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: userData['profil']?.isNotEmpty ?? false
                                    ? Image.network(
                                        userData['profil']!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                          'assets/person.png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/person.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileImageSelection(
                                        userId: user!.uid),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    if (!hasBio)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bio(userId: user!.uid)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Ajouter une bio',
                                style: TextStyle(color: Colors.pink)),
                            const SizedBox(width: 6),
                            const Icon(Icons.mode_edit_outlined,
                                color: Colors.pink),
                          ],
                        ),
                      ),
                    ListTile(
                      title: Text(
                          '${userData['firstName']} ${userData['lastName']}',
                          textAlign: TextAlign.center),
                      subtitle: Text(
                        user != null
                            ? user.email ?? 'Aucun email disponible'
                            : "Veuillez vous connecter.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 200,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfile()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: Colors.pink,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Modifier mon profil',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Suggestions',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, _) {
                    final suggestionsAsync = ref.watch(suggestedUsersProvider);

                    return suggestionsAsync.when(
                      loading: () => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => SizedBox(
                        height: 200,
                        child: Center(
                            child:
                                Text('Veuillez attendre quelques minutes...')),
                      ),
                      data: (userIds) => userIds.isEmpty
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: userIds.length,
                                itemBuilder: (context, index) =>
                                    SuggestionCard(userId: userIds[index]),
                              ),
                            ),
                    );
                  },
                ),
                const Divider(color: Colors.transparent),
                const SizedBox(height: 10),
                TabBar(tabs: tabs),
                SizedBox(
                  height: 400,
                  child: TabBarView(children: tabBarViews),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SuggestionCard extends ConsumerWidget {
  final String userId;

  const SuggestionCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final userAsync = ref.watch(getUserInfoByIdProvider(userId));
    final friendRepo = ref.read(friendProvider);

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white, width: 0.2),
      ),
      child: Container(
        width: 150,
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Erreur: $error')),
          data: (userData) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(
                      userId: userId,
                      isSelfProfile: currentUserId == userId,
                    ),
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: userData['profil']?.isNotEmpty ?? false
                      ? NetworkImage(userData['profil']!)
                      : NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/11/14/17/39/person-1824147_640.png"),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Gérer l'erreur de chargement d'image
                    debugPrint('Erreur de chargement de l\'image: $exception');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userData['pseudo'] ?? 'Anonyme',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              StreamBuilder<List<String>>(
                  stream: friendRepo.getSentRequests(),
                  builder: (context, snapshot) {
                    final hasSentRequest =
                        snapshot.data?.contains(userId) ?? false;

                    return ElevatedButton(
                      onPressed: hasSentRequest
                          ? null
                          : () async {
                              final result = await friendRepo.sendFriendRequest(
                                  userId: userId);
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur: $result')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasSentRequest ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        hasSentRequest ? 'Demande envoyée' : 'Suivre',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildErrorWidget(String message) => Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
