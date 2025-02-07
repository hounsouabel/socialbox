import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Widget pour afficher une vignette de vidéo (sans lecture automatique)
class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
// Ne lancez pas la vidéo automatiquement
          _controller.pause();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }
// Affiche simplement le premier frame de la vidéo
    return VideoPlayer(_controller);
  }
}
