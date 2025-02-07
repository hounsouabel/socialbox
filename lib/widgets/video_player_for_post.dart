import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/post.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Post videoPost;

  const VideoPlayerWidget({super.key, required this.videoPost});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPost.fileUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          // Optionnel : démarrez la vidéo en mode muet
          _controller.setVolume(0.0);
          _controller.play();
          _controller.setLooping(true);
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
    return VideoPlayer(_controller);
  }
}
