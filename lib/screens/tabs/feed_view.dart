import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:groupe7/providers/get_all_image_posts.dart';

import '../../models/post.dart';
import '../image_plein_ecran.dart';

class FeedView extends ConsumerWidget {
  final String userId;

  const FeedView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(getImagePostsProvider(userId));

    return postsAsync.when(
      data: (posts) => _buildGrid(posts, context),
      error: (error, _) => _buildError(error),
      loading: () => _buildLoading(),
    );
  }

  Widget _buildGrid(List<Post> posts, BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text("Aucune publication"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemSize = constraints.maxWidth / 2;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildImageItem(post.fileUrl, context);
          },
        );
      },
    );
  }

  Widget _buildImageItem(String? url, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(imageUrl: url),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        child: url != null
            ? CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholder(),
          errorWidget: (_, __, ___) => _buildErrorIcon(),
        )
            : _buildErrorIcon(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorIcon() {
    return const Icon(Icons.error, color: Colors.red, size: 40);
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Erreur: ${error.toString()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
    );
  }
}