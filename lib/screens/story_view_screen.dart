import 'package:flutter/material.dart';
import '../models/stories/story.dart';

class StoryViewScreen extends StatelessWidget {
  final Story story;

  const StoryViewScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.network(
              story.imageUrl.isNotEmpty ? story.imageUrl : "https://via.placeholder.com/500",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
