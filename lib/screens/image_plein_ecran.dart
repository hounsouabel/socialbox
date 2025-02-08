import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../widgets/comment_screen.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/person.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LikeButton(
                size: 25,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    size: 25,
                    color: isLiked ? Colors.red : Colors.white,
                  );
                },
                likeCount: 1,
                countBuilder: (int? count, bool isLiked, String text) {
                  var color = isLiked ? Colors.red :Colors.white;
                  Widget result;
                  if (count == 0) {
                    result = Text(
                      'like',
                      style: TextStyle(color: color),
                    );
                  } else {
                    result = Text(
                      text,
                      style: TextStyle(color: color),
                    );
                  }
                  return result;
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment, size: 25, color: Colors.white,),
              ),
            ],
          ),
          SizedBox(height: 20), // Add some space at the bottom
        ],
      ),
    );
  }
}