import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class FriendRepository {
  final _myUid = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;

  // Send friend request
  Future<String?> sendFriendRequest({
    required String userId,
  }) async {
    try {
      // Add my uid to other person's received requests
      _firestore.collection('users').doc(userId).update({
        'receivedRequests': FieldValue.arrayUnion(
          [_myUid],
        ),
      });

      // Add other person's uid inside my own sent requests
      _firestore.collection('users').doc(_myUid).update({
        'sentRequests': FieldValue.arrayUnion(
          [userId],
        ),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Accept friend request
  Future<String?> acceptFriendRequest({
    required String userId,
  }) async {
    try {
      // add your uid inside other person's friend list
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'friends': FieldValue.arrayUnion([_myUid])
      });

      // add other person's id inside your own friends list
      await _firestore
          .collection('users')
          .doc(_myUid)
          .update({
        'friends': FieldValue.arrayUnion([userId])
      });

      // remove sent and received friend requests
      removeFriendRequest(userId: userId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> removeFriendRequest({
    required String userId,
  }) async {
    try {
      // Add my uid to other person's received requests
      _firestore.collection('users').doc(userId).update({
        'receivedRequests': FieldValue.arrayRemove([_myUid]),
        'sentRequests': FieldValue.arrayRemove([_myUid]),
      });

      // Add other person's uid inside my own sent requests
      _firestore.collection('users').doc(_myUid).update({
        'sentRequests': FieldValue.arrayRemove([userId]),
        'receivedRequests': FieldValue.arrayRemove([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Accept friend request
  Future<String?> removeFriend({
    required String userId,
  }) async {
    try {
      // add your uid inside other person's friend list
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'friends': FieldValue.arrayRemove([_myUid])
      });

      // add other person's id inside your own friends list
      await _firestore
          .collection('users')
          .doc(_myUid)
          .update({
        'friends': FieldValue.arrayRemove([userId])
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<String>> getReceivedRequests() {
    return _firestore.collection('users').doc(_myUid).snapshots().map((doc) {
      return List<String>.from(doc.data()?['receivedRequests'] ?? []);
    });
  }

  // Récupérer les demandes d'amis envoyées
  Stream<List<String>> getSentRequests() {
    return _firestore.collection('users').doc(_myUid).snapshots().map((doc) {
      return List<String>.from(doc.data()?['sentRequests'] ?? []);
    });
  }
}