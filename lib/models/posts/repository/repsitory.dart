// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:groupe7/models/posts/post.dart';

@immutable
class PostRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  final cloudinary = Cloudinary.fromStringUrl(
      'cloudinary://837771674223148:9mnsJFyFSNRI7SsT3kPcgSpwSPY@davhr8fip');

  /// Crée un post et le télécharge sur Firebase et Cloudinary
  Future<String?> makePost({
    required String content,
    required File file,
    required String postType, // 'image' ou 'video'
  }) async {
    try {
      // Vérifications préliminaires
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Aucun utilisateur connecté.');
      }

      if (postType != 'image' && postType != 'video') {
        throw Exception('Type de post invalide. Utilisez "image" ou "video".');
      }

      final String postId = const Uuid().v4();
      final String posterId = currentUser.uid;
      final DateTime now = DateTime.now();

      // Upload du fichier sur Cloudinary
      final response = await cloudinary.uploader().upload(
            file,
            params: UploadParams(
              uniqueFilename: false,
              overwrite: false,
              publicId: const Uuid().v4(),
              resourceType: postType == 'video' ? 'video' : 'image',
            ),
          );

      if (response == null || response.data?.secureUrl == null) {
        throw Exception('Échec du téléversement sur Cloudinary.');
      }

      final String? downloadUrl = response.data!.secureUrl;

      // Création de l'objet Post
      final Post post = Post(
        postId: postId,
        posterId: posterId,
        content: content,
        postType: postType,
        fileUrl: downloadUrl,
        createdAt: now,
        likes: const [],
      );

      // Sauvegarde du post dans Firestore
      await _firestore.collection('posts').doc(postId).set(post.toMap());

      return null; // Succès
    } catch (e) {
      return e.toString(); 
    }
  }

  // Like a post
  Future<String?> likeDislikePost({
    required String postId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;

      if (likes.contains(authorId)) {
        // we already liked the post
        _firestore
            .collection('posts')
            .doc(postId)
            .update({
         'likes': FieldValue.arrayRemove([authorId])
        });
      } else {
        // we need to like the post
        _firestore
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([authorId])
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
