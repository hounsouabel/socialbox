import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PostScreen extends StatelessWidget {
  // Méthode pour récupérer les posts depuis Firestore
  Future<List<String>> fetchPosts() async {
    List<String> posts = [];
    try {
      // Récupérer les documents de la collection 'posts'
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
      for (var doc in snapshot.docs) {
        // Ajouter le contenu du post à la liste
        posts.add(doc['content']); // Assurez-vous que 'content' est le bon champ
      }
    } catch (e) {
      print('Erreur lors de la récupération des posts: $e');
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun post disponible'));
          } else {
            // Afficher les posts
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    posts[index],
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}