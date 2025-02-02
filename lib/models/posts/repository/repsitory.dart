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

import '../../comment.dart';

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

  ///Fonction servant à liker des pots (fonctionnel | ne pas toucher )
  Future<String?> likeDislikePost({
    required String postId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;

      if (likes.contains(authorId)) {
        ///si le post est déja liké alors on le dislike
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([authorId])
        });
      } else {
        // on like le post
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([authorId])
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Supprime un post et tous les commentaires associés en fonction de l'Id
  Future<String?> deletePost({required String postId}) async {
    try {
      // Vérifier que l'utilisateur est bien connecté
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return 'Utilisateur non connecté';
      }

      // Cr"ation d'un "batch"
      WriteBatch batch = _firestore.batch();

      // Référence au document du post
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      batch.delete(postRef);

      // Récupérer tous les commentaires associés au post
      QuerySnapshot commentsSnapshot = await _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .get();

      // Pour chaque commentaire, une suppression est ajoutée dans le batch
      for (QueryDocumentSnapshot commentDoc in commentsSnapshot.docs) {
        batch.delete(commentDoc.reference);
      }

      // Exécuter le batch
      await batch.commit();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  ///Fonction servant à créer un commentaire dans la bdd

  Future<String?> makeComment({
    required String text,
    required String postId,
  }) async {
    try {
      final commentId = const Uuid().v1();
      final authorId = _auth.currentUser!.uid;
      final now = DateTime.now();

      // Create our post
      Comment comment = Comment(
        commentId: commentId,
        authorId: authorId,
        postId: postId,
        text: text,
        createdAt: now,
        likes: const [],
      );

      // Post to firestore
      _firestore.collection('comments').doc(commentId).set(comment.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  ///Fonction permettant de réagir à un comment
  Future<String?> likeDislikeComment({
    required String commentId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;

      if (likes.contains(authorId)) {
        // we already liked the post
        _firestore.collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayRemove([authorId])
        });
      } else {
        // we need to like the post
        _firestore.collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayUnion([authorId])
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Supprime un commentaire en fonction de son ID.
  Future<String?> deleteComment({required String commentId}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return 'Utilisateur non connecté';
      }

      await _firestore.collection('comments').doc(commentId).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
