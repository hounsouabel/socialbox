import 'package:flutter/material.dart';

class StoriesSection extends StatelessWidget {
  final List<String> storyImages;
  final String profileImage;

  const StoriesSection({
    super.key,
    required this.storyImages,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Story',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              height: 85, // Hauteur fixe pour la section des stories
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAddStoryButton(),
                    const SizedBox(width: 10.0),
                    ..._buildStoryImagesWithSpacing(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Votre Story',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStoryImagesWithSpacing() {
    return storyImages
        .map((image) => Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: _buildStoryImage(image),
    ))
        .toList();
  }

  Widget _buildAddStoryButton() {
    return SizedBox(
      width: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              profileImage,
              height: 65,
              width: 65,
              fit: BoxFit.cover,
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage(String image) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink, width: 2.0),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          image,
          height: 65,
          width: 65,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}