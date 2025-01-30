import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/screens/bio.dart';
import 'package:groupe7/screens/profile_image_selection.dart';
import 'package:groupe7/screens/settings/settings.dart';
import 'package:groupe7/screens/update_profile.dart';

import '../home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return _buildErrorWidget('Utilisateur non connecté');
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget('Erreur de chargement');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final hasBio = (userData['bio'] as String?)?.isNotEmpty ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _ProfileHeader(user: _user, userData: userData),
                if (!hasBio) _BioButton(user: _user),
                _UserInfo(userData: userData),
                const _ProfileActions(),
                const _ProfileMenu(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) => Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      );
}

class _ProfileHeader extends StatelessWidget {
  final User user;
  final Map<String, dynamic> userData;

  const _ProfileHeader({required this.user, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _getProfileImage(),
          backgroundColor: Colors.grey[200],
        ),
        _EditProfileButton(user: user),
      ],
    );
  }

  ImageProvider _getProfileImage() {
    final profileUrl = userData['profil'] as String?;
    return (profileUrl?.isNotEmpty ?? false)
        ? NetworkImage(profileUrl!)
        : const AssetImage('assets/person.png') as ImageProvider;
  }
}

class _EditProfileButton extends StatelessWidget {
  final User user;

  const _EditProfileButton({required this.user});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.edit, size: 20, color: Colors.white),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileImageSelection(userId: user.uid),
        ),
      ),
    );
  }
}

class _BioButton extends StatelessWidget {
  final User user;

  const _BioButton({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bio(userId: user.uid)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ajouter une bio', style: TextStyle(color: Colors.pink)),
            SizedBox(width: 6),
            Icon(Icons.mode_edit_outlined, color: Colors.pink, size: 18),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final Map<String, dynamic> userData;

  const _UserInfo({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            '${userData['firstName']} ${userData['lastName']}',
            //style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            userData['email'] ?? 'Aucun email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  const _ProfileActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UpdateProfile()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: const Text(
            'Modifier le profil',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileMenuItem(title: 'Paramètres', icon: Icons.settings,onTap: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );},),
        // _ProfileMenuItem(title: 'Facturation', icon: Icons.payment),
        _ProfileMenuItem(title: 'Gestion compte', icon: Icons.manage_accounts),
        const Divider(),
        const SizedBox(height: 10),
        _ProfileMenuItem(title: 'Informations', icon: Icons.info),
        _ProfileMenuItem(
          title: 'Déconnexion',
          icon: Icons.logout,
          color: Colors.red,
          onTap: () {
            FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? Colors.blueAccent),
      ),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.navigate_next, color: Colors.grey),
    );
  }
}
