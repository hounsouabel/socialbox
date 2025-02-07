import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/get_all_video_posts_by_userId.dart';
import '../../widgets/video_thumbnail_widget.dart';
import '../full_screen_video.dart';

class VideoView extends ConsumerWidget {
  final dynamic userId;

  const VideoView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Définir la couleur du texte selon le mode clair/sombre
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final videoPostsAsync = ref.watch(videoPostsProvider(userId));

    return videoPostsAsync.when(
      data: (videos) {
        if (videos.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoPost = videos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      height: 250,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenVideoScreen(
                                  videoUrl: videoPost.fileUrl,
                                  post: videoPost,
                                ),
                              ),
                            );
                          },
                          child:
                              VideoThumbnailWidget(videoUrl: videoPost.fileUrl),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Erreur: $error")),
    );
  }
}
