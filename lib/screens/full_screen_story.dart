import 'package:flutter/material.dart';
import '../models/stories/story.dart';

class FullScreenStory extends StatefulWidget {
  final Story story;

  const FullScreenStory({super.key, required this.story});

  @override
  State<FullScreenStory> createState() => _FullScreenStoryState();
}

class _FullScreenStoryState extends State<FullScreenStory> {
  @override
  Widget build(BuildContext context) {
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
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            widget.story.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
