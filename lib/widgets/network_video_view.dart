import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoView extends StatefulWidget {
  const NetworkVideoView({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
  });

  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool showControls;

  @override
  State<NetworkVideoView> createState() => _NetworkVideoViewState();
}

class _NetworkVideoViewState extends State<NetworkVideoView> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
            ..addListener(() {
              if (mounted) {
                setState(() {});
              }
            });

      await _videoController.initialize();

      if (widget.autoPlay) {
        _videoController.play();
        _isPlaying = true;
      }

      _videoController.setLooping(widget.looping);

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = "Erreur de chargement: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(() {});
    _videoController.pause();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorUI();
    }

    if (!_isInitialized) {
      return _buildLoadingUI();
    }

    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController),
          if (widget.showControls)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isPlaying) {
                      _videoController.pause();
                    } else {
                      _videoController.play();
                    }
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 50,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // UI de chargement
  Widget _buildLoadingUI() {
    return Container(
      height: 300,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  // UI d'erreur
  Widget _buildErrorUI() {
    return Container(
      height: 300,
      color: Colors.red[900],
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 50),
          const SizedBox(height: 20),
          Text(
            _errorMessage ?? "Impossible de charger la vidéo",
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _initializeVideo,
            child: const Text("Réessayer"),
          ),
        ],
      ),
    );
  }
}
