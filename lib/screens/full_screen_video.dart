import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/post.dart';
import '../providers/get_user_info_by_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/post_footer.dart';

class FullScreenVideoScreen extends ConsumerStatefulWidget {
  final String videoUrl;
  final Post post;

  const FullScreenVideoScreen({
    super.key,
    required this.videoUrl,
    required this.post,
  });

  @override
  ConsumerState<FullScreenVideoScreen> createState() =>
      _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends ConsumerState<FullScreenVideoScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des infos de l'utilisateur grâce à son id
    final userInfo = ref.watch(getUserInfoByIdProvider(widget.post.posterId));
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _isInitialized
                  ? GestureDetector(
                onTap: _togglePlayPause,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
                  : const CircularProgressIndicator(),
            ),
            const SizedBox(height: 10),
            // Affichage de la description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: userInfo.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(
                  'Erreur: $error',
                  style: const TextStyle(color: Colors.white),
                ),
                data: (userData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       /* Text(
                          userData["pseudo"] ?? "Utilisateur inconnu",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),*/
                        const SizedBox(height: 4),
                        /*Text(
                          widget.post.content,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),*/
                    ExpandableRichText(
                      pseudo: userData["pseudo"]+"  ",
                      content: widget.post.content,
                      trimLines: 3,
                      pseudoStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:  Colors.white ,
                      ),
                      contentStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color:  Colors.white ,
                      ),
                    )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
