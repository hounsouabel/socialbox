import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/get_all_pots_provider.dart';
import '../widgets/post_widget.dart';
import 'loader.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),
        PostsList(),
      ],
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
                      // Trigger a refresh or retry logic
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
