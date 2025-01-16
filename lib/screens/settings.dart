import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/home.dart';
import 'package:groupe7/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SettingsPage> {
  String _userName = 'Utilisateur';
  bool _isLoading = true;

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
          _isLoading = false;
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ListView(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(_userName),
                        subtitle: Text(user != null
                            ? user.email ?? 'Aucun email disponible'
                            : "Veuillez vous connecter."),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.color_lens,
                              size: 30,
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                "  Apparence",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              size: 30,
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                "  Langue",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.account_box_outlined,
                              size: 30,
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                "  Compte",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.settings,
                              size: 30,
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                "  Paramètres",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                          indent: 2.0,
                          endIndent: 40.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 30,
                            ),
                            TextButton(
                                onPressed: () {
                                  AuthService authService = AuthService();
                                  authService.signOut();

                                  // Rediriger vers la page initiale
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text(
                                  "Déconnexion",
                                  style: TextStyle(fontSize: 18),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
    );
  }
}
