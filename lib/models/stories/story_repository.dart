import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:groupe7/models/stories/story.dart';
import 'package:uuid/uuid.dart';


import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

@immutable
class StoryRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.fromStringUrl('cloudinary://837771674223148:9mnsJFyFSNRI7SsT3kPcgSpwSPY@davhr8fip');

  Future<String?> postStory({
    required File image,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      final storyId = const Uuid().v4();
      final now = DateTime.now();

      // Upload vers Cloudinary
      final response = await _cloudinary.uploader().upload(
        image,
        params: UploadParams(
          uniqueFilename: true,
          overwrite: false,
          publicId: const Uuid().v4(),
          resourceType: 'image',
        ),
      );

      if (response == null || response.data?.secureUrl == null) {
        throw Exception('Échec du téléversement sur Cloudinary');
      }

      // Création de la story
      final Story story = Story(
        imageUrl: response.data!.secureUrl!,
        createdAt: now,
        storyId: storyId,
        authorId: user.uid,
        views: const [],
      );

      // Sauvegarde dans Firestore
      await _firestore.collection('stories').doc(storyId).set(story.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }
///Suprimer une story...
  Future<String?> deleteStory({required String storyId}) async {
    try {
      final user = _auth.currentUser ;
      if (user == null) throw Exception('Utilisateur non connecté');

      // Vérifiez si l'utilisateur est l'auteur de la story
      final storyDoc = await _firestore.collection('stories').doc(storyId).get();
      if (!storyDoc.exists) {
        throw Exception('Story non trouvée');
      }

      final storyData = storyDoc.data();
      if (storyData?['authorId'] != user.uid) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer cette story');
      }

      // Supprimer la story de Firestore
      await _firestore.collection('stories').doc(storyId).delete();

      return null; // Retourne null si la suppression a réussi
    } catch (e) {
      return e.toString(); // Retourne l'erreur en cas d'échec
    }
  }

  Future<String?> viewStory({required String storyId}) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Utilisateur non connecté');

      await _firestore.collection('stories').doc(storyId).update({
        'views': FieldValue.arrayUnion([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}