import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'content__screen.dart';

class HomePage extends StatelessWidget {
  final List<String> videos = [
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://assets.mixkit.co/active_storage/video_items/100630/1730327585/100630-video-720.mp4',
    'https://assets.mixkit.co/videos/11054/11054-720.mp4',
    'https://assets.mixkit.co/videos/7077/7077-720.mp4',
    'https://assets.mixkit.co/videos/4886/4886-720.mp4',
    'https://assets.mixkit.co/videos/11908/11908-720.mp4'
    'https://artlist.io/stock-footage/clip/happy-loop-2d-anime/760258',

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              //We need swiper for every content
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ContentScreen(
                    src: videos[index],
                  );
                },
                itemCount: videos.length,
                scrollDirection: Axis.vertical,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flutter Shorts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}