import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:groupe7/screens/home_page.dart'; // ChatterBox

class ProfileImageSelection extends StatefulWidget {
  final String userId;

  const ProfileImageSelection({required this.userId, super.key});

  @override
  State<ProfileImageSelection> createState() => _ProfileImageSelectionState();
}

class _ProfileImageSelectionState extends State<ProfileImageSelection> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef = storageRef.child('profile_images/${widget.userId}.jpg');
      await profileImageRef.putFile(_selectedImage!);

      final imageUrl = await profileImageRef.getDownloadURL();

      // Mettre à jour Firestore avec l'URL de l'image
      FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'profileImage': imageUrl,
        'firstLogin': false,
      });

      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const ChatterBox()),
  (Route<dynamic> route) => false, 
);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sélectionnez une image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                : const Icon(Icons.account_circle, size: 150, color: Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Choisir une image'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadImage,
                    child: const Text('Enregistrer'),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .update({'firstLogin': false});
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatterBox()),
                );
              },
              child: const Text('Ignorer'),
            ),
          ],
        ),
      ),
    );
  }
}
