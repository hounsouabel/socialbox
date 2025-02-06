import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friends/friend_repository.dart';
import '../providers/friend_provider.dart';
import '../widgets/request_tile.dart';


class FriendRequestsScreen extends ConsumerWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2, // Deux onglets
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Demandes d'amitié"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Invitations reçues"),
              Tab(text: "Demandes envoyées"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ReceivedRequestsTab(), // Onglet pour les invitations reçues
            SentRequestsTab(), // Onglet pour les demandes envoyées
          ],
        ),
      ),
    );
  }
}

class ReceivedRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRepo = ref.watch(friendProvider);

    return StreamBuilder<List<String>>(
      stream: friendRepo.getReceivedRequests(), // Méthode à créer dans FriendRepository
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final requests = snapshot.data ?? [];
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return RequestTile(userId: requests[index]); // Utilisez RequestTile pour afficher chaque demande
          },
        );
      },
    );
  }
}

class SentRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRepo = ref.watch(friendProvider);

    return StreamBuilder<List<String>>(
      stream: friendRepo.getSentRequests(), // Méthode à créer dans FriendRepository
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final requests = snapshot.data ?? [];
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return RequestTile(userId: requests[index]); // Utilisez RequestTile pour afficher chaque demande
          },
        );
      },
    );
  }
}