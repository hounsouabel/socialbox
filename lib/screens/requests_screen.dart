import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friends/friend_repository.dart';
import '../providers/friend_provider.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../widgets/request_tile.dart';

class FriendRequestsScreen extends ConsumerWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: "Invitations reçues"),
              Tab(text: "Demandes envoyées"),
              Tab(text: "Messagerie"),
            ],
            labelColor: isDarkMode ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.pink,
            indicatorWeight: 4.0,
          ),
        ),
        body: TabBarView(
          children: [
            ReceivedRequestsTab(),
            SentRequestsTab(),
            MessagerieTab(),
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
      stream: friendRepo.getReceivedRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(ref, snapshot.error.toString());
        }

        final requests = snapshot.data ?? [];

        return requests.isEmpty
            ? const Center(child: Text("Aucune demande reçue"))
            : ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final userId = requests[index];
            return Consumer(
              builder: (context, ref, _) {
                final userAsync = ref.watch(getUserInfoByIdProvider(userId));
                return userAsync.when(
                  loading: () => const ListTile(
                    leading: CircularProgressIndicator(),
                  ),
                  error: (error, _) => ListTile(
                    title: Text('Erreur de chargement'),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => ref.refresh(getUserInfoByIdProvider(userId)),
                    ),
                  ),
                  data: (userData) => RequestTile(
                    userId: userId,
                    userName: userData['pseudo'] ?? 'Utilisateur inconnu',
                    userImage: userData['profil'],
                    onAccept: () => _handleAcceptRequest(userId, ref, context),
                    onReject: () => _handleRejectRequest(userId, ref, context),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleAcceptRequest(String userId, WidgetRef ref, BuildContext context) {
    try {
      ref.read(friendProvider).acceptFriendRequest(userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande acceptée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  void _handleRejectRequest(String userId, WidgetRef ref, BuildContext context) {
    try {
      ref.read(friendProvider).removeFriendRequest(userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande rejetée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Widget _buildErrorWidget(WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Erreur: $error', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => ref.invalidate(friendProvider),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

class SentRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRepo = ref.watch(friendProvider);

    return StreamBuilder<List<String>>(
      stream: friendRepo.getSentRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(ref, snapshot.error.toString());
        }

        final requests = snapshot.data ?? [];

        return requests.isEmpty
            ? const Center(child: Text("Aucune demande envoyée"))
            : ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final userId = requests[index];
            return Consumer(
              builder: (context, ref, _) {
                final userAsync = ref.watch(getUserInfoByIdProvider(userId));
                return userAsync.when(
                  loading: () => const ListTile(
                    leading: CircularProgressIndicator(),
                  ),
                  error: (error, _) => ListTile(
                    title: Text('Erreur de chargement'),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => ref.refresh(getUserInfoByIdProvider(userId)),
                    ),
                  ),
                  data: (userData) => RequestTile(
                    userId: userId,
                    userName: userData['pseudo'] ?? 'Utilisateur inconnu',
                    userImage: userData['profil'],
                    isSentRequest: true,
                    onCancel: () => _handleCancelRequest(userId, ref, context),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleCancelRequest(String userId, WidgetRef ref, BuildContext context) {
    try {
      ref.read(friendProvider).removeFriendRequest(userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande annulée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Widget _buildErrorWidget(WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Erreur: $error', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => ref.invalidate(friendProvider),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

class MessagerieTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Fonctionnalité de messagerie à venir',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}