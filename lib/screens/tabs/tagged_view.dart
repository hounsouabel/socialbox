import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post.dart';

import '../../providers/get_favorite_post_provider.dart';
import '../full_screen_video.dart';
import '../../widgets/video_thumbnail_widget.dart'; 

class TaggedView extends ConsumerWidget {
  const TaggedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePostsAsync = ref.watch(getFavoritePostsProvider);

    return favoritePostsAsync.when(
      data: (posts) => _buildGrid(posts, context), // Passer context ici
      error: (error, _) => _buildError(error),
      loading: () => _buildLoading(),
    );
  }

  Widget _buildGrid(List<Post> posts, BuildContext context) { // Ajouter BuildContext ici
    if (posts.isEmpty) {
      return const Center(child: Text("Aucune publication favorite"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            return _buildPostItem(post, context); // Passer context ici
          },
        );
      },
    );
  }

  Widget _buildPostItem(Post post, BuildContext context) { // Ajouter BuildContext ici
    if (post.postType == 'image') {
      return GestureDetector(
          onTap: () {
            // Naviguer vers l'écran d'image pleine
            // Remplacez par votre logique de navigation
          },
          child: Image.network(
            post.fileUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
          ));
          } else if (post.postType == 'video') {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenVideoScreen(
                    videoUrl: post.fileUrl,
                    post: post,
                  ),
                ),
              );
            },
            child: VideoThumbnailWidget(videoUrl: post.fileUrl)
        );
      } else {
      return _buildErrorIcon(); // Gérer les types de post non reconnus
    }
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