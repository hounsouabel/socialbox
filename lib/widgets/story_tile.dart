import 'package:flutter/material.dart';

class StoryTile extends StatelessWidget {
  final String imageUrl;

  const StoryTile({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 100,
          width: 110,
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl, fit: BoxFit.cover)
              : Container(
            color: Colors.grey,
            child: const Icon(Icons.image, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
