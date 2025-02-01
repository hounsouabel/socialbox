import 'package:flutter/material.dart';
import 'package:groupe7/services/auth_service.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final AuthService _authService = AuthService();
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _authService.getBasicUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          final userInfo = snapshot.data!;
          final profilePicUrl = userInfo['profil'] ?? 'https://img.icons8.com/?size=100&id=98957&format=png&color=000000';
          final fullName = '${userInfo['pseudo']}';

          return Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
              const SizedBox(width: 10),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        return const Text('Aucune donnée utilisateur.');
      },
    );
  }
}
