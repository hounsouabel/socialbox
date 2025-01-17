import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres du compte"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
             Row(
              children: [
                Icon(
                  Icons.security,
                  size: 25,
                ),
                Text(
                  ("  Mot de passe et Sécurité"),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(
                  Icons.update,
                  size: 25,
                ),
                Text(
                  ("  Informations personnelles"),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(
                  Icons.save,
                  size: 25,
                ),
                Text(
                  ("   Enregistrer vos informations"),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(
                  Icons.delete_forever,
                  size: 25,
                ),
                Text(
                  ("  Supprimer votre compte "),
                  style: TextStyle(fontSize: 18,color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
