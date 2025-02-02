import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/screens/bio.dart';
import 'package:groupe7/screens/profile_image_selection.dart';

import 'package:groupe7/screens/tabs/feed_view.dart';
import 'package:groupe7/screens/tabs/reels_view.dart';
import 'package:groupe7/screens/tabs/tagged_view.dart';
import 'package:groupe7/screens/update_profile.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    Tab(
      icon: Icon(
        Icons.image,
        color: Colors.grey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.video_collection,
        color: Colors.grey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.bookmark,
        color: Colors.grey,
      ),
    ),
  ];

  final List<Widget> tabBarViews = [
    FeedView(),
    ReelsView(),
    TaggedView(),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('364',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 5),
                        Text('Suivis', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: userData['profil']?.isNotEmpty ?? false
                                  ? Image.network(
                                // Affiche l'image depuis Firestore
                                userData['profil']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  // Fallback si l'URL est invalide
                                  'assets/person.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Image.asset(
                                // Asset par défaut
                                'assets/person.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileImageSelection(
                                              userId: user!.uid),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('364',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 5),
                        Text('Abonnés', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                            Text('Ajouter une bio',
                                style: TextStyle(color: Colors.pink)),
                            SizedBox(width: 6),
                            Icon(Icons.mode_edit_outlined, color: Colors.pink),
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
                        constraints: BoxConstraints(
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Suggestions',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      suggestionCard('assets/story1.jpg', 'Titre 1'),
                      suggestionCard('assets/story2.jpg', 'Titre 2'),
                      suggestionCard('assets/story3.jpg', 'Titre 3'),
                      suggestionCard('assets/story4.jpg', 'Titre 4'),
                    ],
                  ),
                ),
                const Divider(color: Colors.transparent),
                const SizedBox(height: 10),
                TabBar(
                  tabs: tabs,
                ),
                SizedBox(
                  height: 1000,
                  child: TabBarView(
                    children: tabBarViews,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget pour créer une carte de suggestion
  Widget suggestionCard(String imagePath, String title) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            10), // Ajoutez un rayon pour les coins arrondis
        side: BorderSide(
            color: Colors.white,
            width: 0.2), // Ajoutez une bordure blanche fine
      ),
      child: Container(
        width: 150, // Set a fixed width for the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius:
              40, // Réduisez le rayon de l'image pour la rendre plus petite
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                // Logique pour suivre l'utilisateur
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Suivre', style: TextStyle(color: Colors.white)),
            ),
          ],
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
