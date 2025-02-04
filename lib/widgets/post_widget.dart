import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout pour récupérer l'utilisateur actuel

import 'package:video_player/video_player.dart';
import '../models/post.dart';
import '../providers/general_provider.dart';
import '../screens/full_image_screen.dart';
import '../widgets/post_footer.dart';
import '../widgets/post_header.dart';
import 'package:groupe7/widgets/comment_screen.dart';

class PostWidget extends ConsumerWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Vérifie si `posterId` est valide
    if (post.posterId.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("ID de l'afficheur manquant"),
      );
    }

    return Padding(
      ///toujours garder à 0
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(userId: post.posterId, postId: post.postId,),
          const SizedBox(height: 8),
          _buildPostImage(context),
          _buildPostActions(context, ref),
          PostFooter(userId: post.posterId, post: post),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Widget pour afficher l'image ou la vidéo du post
  Widget _buildPostImage(BuildContext context) {
    if (post.fileUrl.isEmpty) return const SizedBox();

    if (post.postType == 'image') {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImageScreen(imageUrl: post.fileUrl, post: post,),
            ),
          );
        },
        child: Image.network(
          post.fileUrl,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return _buildVideoThumbnail(post.fileUrl);
    }
  }


  Widget _buildVideoThumbnail(String videoUrl) {
    return VideoPlayerWidget(videoUrl: videoUrl);
  }




  /// Widget pour afficher les boutons d'action sous le post (Like, Comment, Share)
  Widget _buildPostActions(BuildContext context, WidgetRef ref) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Récupérer l'ID de l'utilisateur connecté
    final bool isLiked = post.likes.contains(currentUserId); // Vérifier si l'utilisateur a liké le post
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Bouton Like
          LikeButton(
            size: 25,
            isLiked: isLiked, // Vérification correcte
            onTap: (isLiked) async {
              await ref.read(globalProvider).likeDislikePost(
                postId: post.postId,
                likes: post.likes,
              );
              return !isLiked;
            },
            likeBuilder: (bool isLiked) {
              return Icon(
                isLiked ? Icons.favorite : Icons.favorite_border_outlined, // Affiche l'icône favorite ou favorite_border_outlined
                size: 25,
                color: isLiked ? Colors.red : (isDarkMode ? Colors.white : Colors.black), // Couleur de l'icône
              );
            },
            likeCount: post.likes.length,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                count == 0 ? '' : text,
                style: TextStyle(
                  color: isLiked ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // Bouton Commentaire
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    child: CommentScreen(postId: post.postId),
                  );
                },
              );
            },
            icon: const Icon(Icons.mode_comment_outlined, size: 25),
          ),
          const SizedBox(width: 8),

          // Bouton Partage
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.near_me_outlined, size: 25),
          ),

          const Spacer(),

          // Bouton Enregistrer
          LikeButton(
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.bookmark,
                size: 25,
                color: isLiked ? Colors.yellowAccent : (isDarkMode ? Colors.white : Colors.black),
              );
            },
          ),
        ],
      ),
    );
  }
}
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool allowScreenSleep;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = true,
    this.allowScreenSleep = false,
  });

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isHwCodecProblem = false;
  String? _errorMessage;
  VideoFormat? _formatHint;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _controller?.dispose();
      _chewieController?.dispose();

      _controller = VideoPlayerController.network(
        widget.videoUrl,
        formatHint: _isHwCodecProblem ? VideoFormat.other : null,
      );
      await _controller!.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        allowedScreenSleep: widget.allowScreenSleep,
        errorBuilder: (context, errorMessage) {
          setState(() => _errorMessage = errorMessage.toString());
          return _buildErrorWidget(message: _errorMessage);
        },
      );

      if (mounted) {
        setState(() {
          _isHwCodecProblem = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (!mounted) return;

      if (e.toString().contains('MediaCodec')) {
        _handleHwDecoderError();
      } else {
        setState(() => _errorMessage = 'Erreur: ${e.toString()}');
      }
    }
  }

  void _handleHwDecoderError() {
    if (!_isHwCodecProblem && mounted) {
      setState(() {
        _isHwCodecProblem = true;
        _formatHint = VideoFormat.other; // or another format hint
      });
      _initializeVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorWidget(message: _errorMessage);
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return _buildLoadingIndicator();
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        children: [
          Chewie(controller: _chewieController!),
          if (_isHwCodecProblem)
            Positioned(
              bottom: 10,
              right: 10,
              child: Chip(
                label: const Text('Mode compatibilité activé'),
                backgroundColor: Colors.amber.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildErrorWidget({String? message}) {
    return Container(
      height: 300,
      color: Colors.black,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 50),
          const SizedBox(height: 20),
          Text(
            message ?? 'Impossible de charger la vidéo',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'URL: ${widget.videoUrl}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _initializeVideo,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}