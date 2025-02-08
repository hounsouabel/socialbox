import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String pseudo;
  final String email;
  final String profil;
  final List<String> friends;
  final int createdAt; // Stocké en `int` pour uniformiser avec Firestore

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.pseudo,
    required this.email,
    required this.profil,
    required this.friends,
    required this.createdAt,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'pseudo': pseudo,
      'email': email,
      'profil': profil,
      'friends': friends,
      'createdAt': createdAt, // Stocké en `int`
    };
  }

  // Factory pour créer une instance depuis Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      pseudo: map['pseudo'] ?? '',
      email: map['email'] ?? '',
      profil: map['profil'] ?? '',
      friends: List<String>.from(map['friends'] ?? []),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).millisecondsSinceEpoch // Convertir Timestamp en int
          : (map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}
