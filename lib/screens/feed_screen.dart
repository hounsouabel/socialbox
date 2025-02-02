/*import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:intl/intl.dart';

import '../widgets/comment_screen.dart'; // Import the intl package for date formatting

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Liste des histoires et autres données
  final List<String> storyImages = [
    'assets/story1.jpg',
    'assets/story2.jpg',
    'assets/story3.jpg',
    'assets/story4.jpg',
    'assets/story5.jpg',
    'assets/story6.jpg',
    'assets/story7.jpg',
    'assets/story8.jpg',
    'assets/story9.jpg',
    'assets/story10.jpg',
  ];

  final String userName = 'Abel HOUNSOU';
  final String postImage = 'assets/person1.jpg';
  final String profileImage = 'assets/addpost.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoriesSection(),
            SizedBox(height: 20.0),
           _buildPostSection(),
            _buildPostImage(),
            _buildPostActions(),
            _buildPostDescription(),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher la section des histoires
  Widget _buildStoriesSection() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
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
            softWrap: true, // Text wraps automatically
          ),
          SizedBox(height: 5.0),
          // Utilisation de SingleChildScrollView avec un défilement horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Permet de faire défiler horizontalement
            child: Row(
              children: [
                _buildAddStoryButton(),
                SizedBox(width: 10.0),
                ..._buildStoryImagesWithSpacing(),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Votre Story',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true, // Text wraps automatically
          ),
        ],
      ),
    );
  }

  // Fonction pour construire la liste des images de story avec espacement
  List<Widget> _buildStoryImagesWithSpacing() {
    List<Widget> storyWidgets = [];
    for (int i = 0; i < storyImages.length; i++) {
      storyWidgets.add(_buildStoryImage(storyImages[i]));
      if (i != storyImages.length - 1) {
        storyWidgets.add(SizedBox(width: 10.0));
      }
    }
    return storyWidgets;
  }

  // Widget pour ajouter un bouton d'ajout de story
  Widget _buildAddStoryButton() {
    return Container(
      height: 70,
      width: 70,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              profileImage,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher une image de story
  Widget _buildStoryImage(String image) {
    return Container(
      padding: EdgeInsets.all(2),
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

  // Widget pour afficher le post avec les informations utilisateur
  Widget _buildPostSection() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              profileImage,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Text(
            userName,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            softWrap: true, // Text wraps automatically
          ),
          SizedBox(width: 10),
          Icon(Icons.offline_pin, color: Colors.blue, size: 15),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_outlined, size: 25, color: isDarkMode ? Colors.white : Colors.black),
            onSelected: (String value) {
              if (value == 'delete') {
                // Perform delete action
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  // Widget pour afficher l'image du post
  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset(
        postImage,
        height: 300,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  // Widget pour afficher les actions sous le post
  Widget _buildPostActions() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
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
          ),
          SizedBox(width: 2),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: EdgeInsets.all(10),
                    child: TestMe(),
                  );
                },
              );
            },
            icon: Icon(
              Icons.mode_comment_outlined,
              size: 25,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(width: 2),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.near_me_outlined, size: 25, color: isDarkMode ? Colors.white : Colors.black),
          ),
          Spacer(),
          LikeButton(
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.bookmark,
                size: 25,
                color: isLiked ? Colors.yellowAccent : isDarkMode ? Colors.white : Colors.black,
              );
            },
          )
        ],
      ),
    );
  }

  // Widget pour afficher la description du post
  Widget _buildPostDescription() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/person2.jpg',
                  height: 25,
                  width: 25,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ' Aimé par ',
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      TextSpan(
                        text: 'Viral ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      TextSpan(
                        text: 'et ',
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      TextSpan(
                        text: '98 autres personnes',
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Abel HOUNSOU: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Text(
                  'Vivre mon rêve #PHOTOSHOOT #DARK-VIBES',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  overflow: TextOverflow.visible, // S'assure que le texte s'affiche correctement
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(10),
                        child: TestMe(),
                      );
                    },
                  );
                },
                child: Text('Voir tous les commentaires', style: TextStyle(color: Colors.grey),))
          ),
        ],
      ),
    );
  }
}
*/





