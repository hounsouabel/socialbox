import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';

class FullScreenImageScreen extends ConsumerWidget {
  final String imageUrl;
  final Post post;

  const FullScreenImageScreen({
    super.key,
    required this.imageUrl,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
          children: [
            // L'image en mode interactif pour zoomer/déplacer
            Expanded(
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
      ),
    );
  }
}
