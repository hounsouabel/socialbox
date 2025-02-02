import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  bool isDarkMode = false;
  int likeCount = 99;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('Admin'),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text('Flutter is beautiful and fast ❤ ..'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                      ),
                      Text('Original Audio - some music track--'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      LikeButton(
                        size: 25,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            size: 25,
                            color: isLiked ? Colors.red : isDarkMode ? Colors.white : Colors.black,
                          );
                        },
                        likeCount: 99,
                        countBuilder: (int? count, bool isLiked, String text) {
                          var color = isLiked ? Colors.red : isDarkMode ? Colors.white : Colors.black;
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
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.comment_rounded),
                  Text('1123'),
                  SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(Icons.send),
                  ),
                  SizedBox(height: 50),
                  Icon(Icons.more_vert),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
