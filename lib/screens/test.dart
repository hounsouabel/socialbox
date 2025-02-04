import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4' as Uri // Remplace avec ton URL
    )
      ..initialize().then((_) {
        setState(() {}); // Met à jour l'interface une fois la vidéo chargée
      })
      ..setLooping(true) // Répète la vidéo en boucle
      ..addListener(() {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Nettoyer la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecteur Vidéo')),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 40,
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  iconSize: 40,
                  onPressed: () {
                    _controller.pause();
                    _controller.seekTo(Duration.zero);
                  },
                ),
              ],
            ),
          ],
        )
            : CircularProgressIndicator(), // Affiche un chargement si la vidéo n'est pas prête
      ),
    );
  }
}
