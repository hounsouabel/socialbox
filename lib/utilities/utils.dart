import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


// pick image method
Future<File?> pickImage() async {
  File? image;
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 720,
    maxWidth: 720,
  );

  if (file != null) {
    image = File(file.path);
  }

  return image;
}





Future<File?> pickVideo() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  if (pickedFile == null) return null;

  final videoFile = File(pickedFile.path);

  // Vérification de la taille (10MB max)
  const maxSize = 10 * 1024 * 1024; // 10MB
  final fileSize = await videoFile.length();
  if (fileSize > maxSize) {
    showToastMessage(text: 'Les vidéos ne doivent pas dépasser 10MB');
    return null;
  }

  // Vérification de la durée et intégrité de la vidéo
  final controller = VideoPlayerController.file(videoFile);
  try {
    await controller.initialize();
    final duration = controller.value.duration;

    const maxDuration = Duration(minutes: 5);
    if (duration > maxDuration) {
      showToastMessage(text: 'Les vidéos ne doivent pas dépasser 5 minutes');
      return null;
    }
  } catch (e) {
    showToastMessage(text: 'Vidéo corrompue ou format non supporté');
    return null;
  } finally {
    await controller.dispose();
  }

  return videoFile;
}

void showToastMessage({required String text}) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

//affiche dynamique timestamp

String formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) {
    return "\u00C0 l'instant"; // A en majuscule => \u00C0 (unicode)
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} min";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} h";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} j";
  } else {
    return DateFormat('dd/MM/yy').format(date);
  }
}
