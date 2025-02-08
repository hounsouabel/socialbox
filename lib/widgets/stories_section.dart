import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/stories/story.dart';
import '../providers/get_all_stories_provider.dart';
import '../models/stories/story_repository.dart';
import '../screens/user_stories_view.dart';

class StoriesSection extends ConsumerWidget {
  final String profileImage;

  const StoriesSection({
    super.key,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;
    final storiesAsync = ref.watch(getAllStoriesProvider);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stories',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              height: 85,
              child: storiesAsync.when(
                data: (stories) {
                  final List<Story> storiesList = stories.toList();

                  // Filtrer les stories de l'utilisateur actuel
                  final List<Story> userStories = storiesList
                      .where((story) => story.authorId == currentUserId)
                      .toList();

                  // Regrouper les stories par authorId (sans l'utilisateur connecté)
                  final Map<String, List<Story>> groupedStories = {};
                  for (var story in storiesList) {
                    if (story.authorId != currentUserId) {
                      groupedStories.putIfAbsent(story.authorId, () => []).add(
                          story);
                    }
                  }

                  // Construire les stories des amis uniquement
                  final List<Widget> storyWidgets = groupedStories.entries.map((
                      entry) {
                    final List<Story> authorStories = entry.value;
                    return GestureDetector(
                      onTap: () async {


                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserStoriesView(userStories: authorStories),
                          ),
                        );
                      },
                      child: _buildStoryImage(authorStories, currentUserId),


                    );
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildAddStoryButton(context, userStories),
                        // Bouton dynamique avec la story de l'utilisateur
                        const SizedBox(width: 10.0),
                        ...storyWidgets,
                        // Stories des amis uniquement
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(
                      child: Text(
                        "Erreur: $error",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 10.0),

          ],
        ),
      ),
    );
  }

  /// 🟢 **Bouton pour ajouter une story ou afficher ses propres stories**
  Widget _buildAddStoryButton(BuildContext context, List<Story> userStories) {
    return GestureDetector(
      onTap: () async {
        if (userStories.isNotEmpty) {
          // 🔹 Si l'utilisateur a des stories, on les affiche
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserStoriesView(userStories: userStories),
            ),
          );
        } else {
          // 🔹 Sinon, on propose d'ajouter une nouvelle story
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
              source: ImageSource.gallery);
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
            }
          }
        }
      },
      child: SizedBox(
        width: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                userStories.isNotEmpty
                    ? userStories.first
                    .imageUrl // 🔹 Si une story existe, l'afficher
                    : profileImage.isNotEmpty
                    ? profileImage
                    : "https://via.placeholder.com/65", // Sinon, afficher la PP
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 65,
                    width: 65,
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🟢 **Afficher une story d'un ami**
  Widget _buildStoryImage(List<Story> authorStories, String currentUserId) {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Correction ici : utiliser millisecondsSinceEpoch sur story.createdAt
    final recentStories = authorStories.where((story) {
      return (now - story.createdAt.millisecondsSinceEpoch) < (24 * 60 * 60 * 1000);
    }).toList();

    if (recentStories.isEmpty) return const SizedBox();

    final hasUnseenStories = recentStories.any((story) => !story.views.contains(currentUserId));

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
              color: hasUnseenStories ? Colors.pink : Colors.grey,
              width: 2.0
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            recentStories.first.imageUrl,
            height: 65,
            width: 65,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 65,
              width: 65,
              color: Colors.grey,
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }





}