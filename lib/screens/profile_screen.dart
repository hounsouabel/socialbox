import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/screens/bio.dart';
import 'package:groupe7/screens/settings.dart';
import 'package:groupe7/screens/update_profile.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60), // Adjust radius for desired circle size
                      child: Image.asset('assets/person.png', fit: BoxFit.cover),
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
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bio()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ajouter une bio', style: TextStyle(color: Colors.pink)),
                    SizedBox(width: 6), // Espace entre l'icône et le texte
                    Icon(Icons.mode_edit_outlined, color: Colors.pink),
                  ],
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(_userName, textAlign: TextAlign.center),
                    subtitle: Text(
                      user != null ? user.email ?? 'Aucun email disponible' : "Veuillez vous connecter.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfile()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink, side: BorderSide.none, shape: const StadiumBorder()
                    ),
                    child: const Text(
                        'Edit Profile', style: TextStyle(color: Colors.white)
                    )
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              ProfileMenuWidget(title: 'Paramètre', icon: Icons.settings, onPress: () { }),
              ProfileMenuWidget(title: 'Billings Details', icon: Icons.details, onPress: () { }),
              ProfileMenuWidget(title: 'User Management', icon: Icons.manage_accounts, onPress: () { }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: 'Information', icon: Icons.info, onPress: () { }),
              ProfileMenuWidget(
                  title: 'Logout',
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () { }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color?  textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blueAccent),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith( // Crée une copie de bodyMedium
        color: textColor, // Modifie uniquement la couleur
      )),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(Icons.navigate_next_outlined, size: 18.0, color: Colors.grey)) : null,
    );
  }
}

