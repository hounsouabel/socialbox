import 'package:flutter/material.dart';
import 'package:groupe7/screens/story_view_screen.dart';
import '../models/stories/story.dart';

class UserStoriesView extends StatefulWidget {
  final List<Story> userStories; // Liste des stories de l'utilisateur

  const UserStoriesView({super.key, required this.userStories});

  @override
  _UserStoriesViewState createState() => _UserStoriesViewState();
}

class _UserStoriesViewState extends State<UserStoriesView> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _nextStory() {
    if (_currentIndex < widget.userStories.length - 1) {
      setState(() {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Stories"),
      ),
      body: Stack(
        children: [
          // Affichage des stories avec swipe
          PageView.builder(
            controller: _pageController,
            itemCount: widget.userStories.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return StoryViewScreen(story: widget.userStories[index]);
            },
          ),

          // Bouton précédent
          if (_currentIndex > 0)
            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height * 0.5 - 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 40),
                onPressed: _previousStory,
              ),
            ),

          // Bouton suivant
          if (_currentIndex < widget.userStories.length - 1)
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height * 0.5 - 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                onPressed: _nextStory,
              ),
            ),
        ],
      ),
    );
  }
}
