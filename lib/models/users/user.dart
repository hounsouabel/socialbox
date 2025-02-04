import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String fullName;
  final DateTime birthDay;
  final String gender;
  final String email;
  final String password;
  final String profilePicUrl;
  final String uid;
  final List<String> friends;
  final List<String> sentRequests;
  final List<String> receivedRequests;

  const UserModel({
    required this.fullName,
    required this.birthDay,
    required this.gender,
    required this.email,
    required this.password,
    required this.profilePicUrl,
    required this.uid,
    required this.friends,
    required this.sentRequests,
    required this.receivedRequests,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'birthDay': birthDay.millisecondsSinceEpoch,
      'gender': gender,
      'email': email,
      'password': password,
      'profilePicUrl': profilePicUrl,
      'uid': uid,
      'friends': friends,
      'sentRequests': sentRequests,
      'receivedRequests': receivedRequests,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String,
      birthDay: DateTime.fromMillisecondsSinceEpoch(map['birthDay'] as int),
      gender: map['gender'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      uid: map['uid'] as String,
      friends: List<String>.from((map['friends'] ?? [])),
      sentRequests: List<String>.from((map['sentRequests'] ?? [])),
      receivedRequests: List<String>.from((map['receivedRequests'] ?? [])),
    );
  }
}