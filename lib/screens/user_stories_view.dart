

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../models/stories/story.dart';
import '../models/stories/story_repository.dart';
import '../providers/get_user_info_by_id_provider.dart';
import 'home_page.dart';


class UserStoriesView extends ConsumerStatefulWidget {
  final List<Story> userStories;

  const UserStoriesView({super.key, required this.userStories});

  @override
  _UserStoriesViewState createState() => _UserStoriesViewState();
}

class _UserStoriesViewState extends ConsumerState<UserStoriesView> {
  int _currentIndex = 0;
  late List<Story> stories;
  late PageController _pageController;
  final StoryRepository _storyRepository = StoryRepository();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  Set<String> viewedStories = {};

  @override
  void initState() {
    super.initState();
    stories = List.from(widget.userStories);
    _pageController = PageController(initialPage: _currentIndex);
    if (stories.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onStoryViewed(stories.first);
      });
    }
  }

  void _markStoryAsViewed(Story story) async {
    if (!story.views.contains(currentUserId)) {
      // Mise à jour optimiste de l'UI avant l'appel Firebase
      setState(() {
        final updatedStory = story.copyWith(
          views: List<String>.from(story.views)..add(currentUserId),
        );
        final index = stories.indexWhere((s) => s.storyId == story.storyId);
        if (index != -1) stories[index] = updatedStory;
      });

      // Envoi asynchrone au backend
      try {
        await _storyRepository.viewStory(storyId: story.storyId);
      } catch (e) {
        // Rollback en cas d'erreur
        setState(() {
          final index = stories.indexWhere((s) => s.storyId == story.storyId);
          if (index != -1) stories[index] = story;
        });
      }
    }
  }


  void _onStoryViewed(Story story) {
    if (!viewedStories.contains(story.storyId)) {
      viewedStories.add(story.storyId);
      _markStoryAsViewed(story);
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

  void _nextStory() {
    if (_currentIndex < stories.length - 1) {
      setState(() {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _deleteCurrentStory() async {
    final story = stories[_currentIndex];
    final result = await _storyRepository.deleteStory(storyId: story.storyId);

    if (result == null) {
      setState(() {
        stories.removeAt(_currentIndex);
        if (stories.isEmpty) {
          Navigator.pop(context);
        } else {
          if (_currentIndex >= stories.length) {
            _currentIndex = stories.length - 1;
          }
          _pageController.jumpToPage(_currentIndex);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final latestStory = stories.isNotEmpty ? stories.first : null;

    if (latestStory == null) {
      return const Scaffold(
        body: Center(child: Text("Aucune story disponible.")),
      );
    }

    final userInfoAsync = ref.watch(getUserInfoByIdProvider(latestStory.authorId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: stories.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _onStoryViewed(stories[index]);
            },
            itemBuilder: (context, index) {
              final story = stories[index];

              // Appel automatique pour la première story au rendu initial
              if (index == 0 && stories.length == 1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onStoryViewed(story);
                });
              }

              return Image.network(
                story.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                userInfoAsync.when(
                  data: (userInfo) => Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userInfo['profil'] ?? ''),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userInfo['pseudo'] ?? 'Utilisateur inconnu',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          // Ajout du nombre de vues
                          Row(
                            children: [
                              Text(
                                timeago.format(stories[_currentIndex].createdAt),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(Icons.remove_red_eye,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${stories[_currentIndex].views.length}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => const Text(
                    "Erreur chargement utilisateur",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    if (stories[_currentIndex].authorId == currentUserId)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: _deleteCurrentStory,
                      ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          if (_currentIndex < stories.length - 1)
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height * 0.5 - 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                onPressed: _nextStory,
              ),
            ),
          // ✅ Bouton "Ajouter une story" si l'utilisateur regarde sa propre story
          if (latestStory.authorId == currentUserId)
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      final storyRepository = StoryRepository();
                      final result = await storyRepository.postStory(
                          image: File(image.path));
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: $result')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Story publiée !')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatterBox(),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter une story"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
