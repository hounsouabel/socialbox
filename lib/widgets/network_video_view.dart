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

  final String videoUrl; // URL de la vidéo
  final bool autoPlay; // Lecture automatique
  final bool looping; // Lecture en boucle
  final bool showControls; // Afficher les contrôles de lecture

  @override
  State<NetworkVideoView> createState() => _NetworkVideoViewState();
}

class _NetworkVideoViewState extends State<NetworkVideoView> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false; // Indique si la vidéo est initialisée
  bool _isPlaying = false; // Indique si la vidéo est en cours de lecture
  String? _errorMessage; // Gestion des erreurs

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Initialisation du contrôleur vidéo
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });

      // Initialisation de la vidéo
      await _videoController.initialize();

      // Démarrage automatique si activé
      if (widget.autoPlay) {
        _videoController.play();
        _isPlaying = true;
      }

      // Activation de la boucle si activée
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
    // Affichage des erreurs
    if (_errorMessage != null) {
      return _buildErrorUI();
    }

    // Affichage du chargement
    if (!_isInitialized) {
      return _buildLoadingUI();
    }

    // Affichage de la vidéo
    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lecteur vidéo
          VideoPlayer(_videoController),

          // Contrôles de lecture
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