import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe7/screens/use_profile.dart'; // Assurez-vous que le nom du fichier est correct

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<User> allUsers = [];
  List<User> suggestedUsers = [];
  List<User> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _getUsers().then((users) {
      setState(() {
        allUsers = users;
      });
    });
  }

  Future<List<User>> _getUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      return User.fromFirestore(doc);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      suggestedUsers = allUsers
          .where((user) => user.pseudo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onUserSelected(User user) {
    setState(() {
      if (!recentSearches.contains(user)) {
        recentSearches.add(user);
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: Text("Amis", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Appbar search
          Container(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              0,
              16.0,
              16.0,
            ),
            color: Colors.pink,
            child: Form(
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                style: TextStyle(color: Colors.black), // Forcer la couleur du texte à noir
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  hintText: "Rechercher",
                  hintStyle: TextStyle(
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5,
                    vertical: 16.0,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  RecentSearchContacts(recentSearches: recentSearches, textColor: textColor),
                  const SizedBox(height: 16.0),
                  SuggestedContacts(
                    suggestedUsers: suggestedUsers,
                    onUserSelected: _onUserSelected,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedContacts extends StatelessWidget {
  final List<User> suggestedUsers;
  final Function(User) onUserSelected;
  final Color textColor;

  const SuggestedContacts({
    super.key,
    required this.suggestedUsers,
    required this.onUserSelected,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Suggestions",
            style: TextStyle(
              color: textColor.withOpacity(0.32),
              fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ...suggestedUsers.map(
              (user) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0 / 2,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.profilePicUrl),
            ),
            title: Text(user.pseudo),
            onTap: () => onUserSelected(user),
          ),
        ),
      ],
    );
  }
}

class RecentSearchContacts extends StatelessWidget {
  final List<User> recentSearches;
  final Color textColor;

  const RecentSearchContacts({super.key, required this.recentSearches, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recherche récente",
            style: TextStyle(
              color: textColor.withOpacity(0.32),
              fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              children: [
                ...List.generate(
                  recentSearches.length,
                      (index) => Positioned(
                    left: index * 48,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(recentSearches[index].profilePicUrl),
                      ),
                    ),
                  ),
                ),
                if (recentSearches.isEmpty)
                  const Center(
                    child: Text("Aucune recherche récente"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedCounter extends StatelessWidget {
  final int total;

  const RoundedCounter({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2E2F45)
            : const Color(0xFFEBFAF3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          "$total+",
          style: titleMedium,
        ),
      ),
    );
  }
}

class User {
  final String pseudo;
  final String profilePicUrl;

  User({required this.pseudo, required this.profilePicUrl});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      pseudo: data['pseudo'] ?? '',
      profilePicUrl: data['profil']?.isNotEmpty ?? false
          ? data['profil']
          : 'https://img.icons8.com/?size=100&id=98957&format=png&color=000000',
    );
  }
}