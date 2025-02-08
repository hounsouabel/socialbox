import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/get_all_pots_provider.dart';
import '../providers/get_user_info_by_id_provider.dart';
import '../widgets/post_widget.dart';
import '../widgets/stories_section.dart';
import 'loader.dart';

class PostsSection extends ConsumerWidget {
  const PostsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userInfo = ref.watch(getUserInfoByIdProvider(userId));

    return userInfo.when(
      data: (userData) {
        final profileImage = userData['profil'] ??
            'https://via.placeholder.com/150'; // Placeholder si pas d'image

        return CustomScrollView(
          key: const PageStorageKey<String>('postsScroll'),
          slivers: [
            StoriesSection(
              profileImage: profileImage,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            const PostsList(),
          ],
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('Erreur: ${error.toString()}'));
      },
      loading: () {
        return const Center(child: Loader());
      },
    );
  }
}

class PostsList extends ConsumerWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(getAllPostsProvider);

    return posts.when(
      data: (postsList) {
        if (postsList.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Aucun post disponible',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = postsList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: PostWidget(post: post),
              );
            },
            childCount: postsList.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Erreur : ${error.toString()}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Rafraîchit le provider pour retenter la récupération des posts.
                      ref.refresh(getAllPostsProvider);
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Loader(),
            ),
          ),
        );
      },
    );
  }
}
