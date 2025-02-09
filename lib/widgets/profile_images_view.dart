import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:groupe7/providers/get_all_image_posts.dart';
import '../../models/post.dart';
import '../screens/full_image_screen.dart';

class ImagesView extends ConsumerWidget {
  final String userId;

  const ImagesView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(getImagePostsProvider(userId));
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photos",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 160,
          child: postsAsync.when(
            data: (posts) => _buildImageList(posts, context), // Passer le contexte ici
            error: (error, _) => _buildError(error),
            loading: () => _buildLoading(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageList(List<Post> posts, BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text("Pas de publications"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: 160,
            width: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageScreen(
                        imageUrl: post.fileUrl,
                        post: post,
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: post.fileUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _buildPlaceholder(),
                  errorWidget: (_, __, ___) => _buildErrorIcon(),
                ),
              ),
            ),
          ),
        );
      },
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
      child: CircularProgressIndicator(),
    );
  }
}