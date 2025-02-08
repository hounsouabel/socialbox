import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:groupe7/screens/home_page.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

class ProfileImageSelection extends StatefulWidget {
  final String userId;

  const ProfileImageSelection({required this.userId, super.key});

  @override
  State<ProfileImageSelection> createState() => _ProfileImageSelectionState();
}

class _ProfileImageSelectionState extends State<ProfileImageSelection> {
  File? _selectedImage;
  bool _isLoading = false;
  final Cloudinary cloudinary = Cloudinary.fromStringUrl('cloudinary://837771674223148:9mnsJFyFSNRI7SsT3kPcgSpwSPY@davhr8fip');

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
      final response = await cloudinary.uploader().upload(
        _selectedImage!,
        params: UploadParams(
          uniqueFilename: false,
          overwrite: true,
          publicId: widget.userId,
          resourceType: 'image',
        ),
      );

      if (response == null || response.data?.secureUrl == null) {
        throw Exception('Échec du téléversement sur Cloudinary.');
      }

      final String downloadUrl = response.data!.secureUrl!;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'profil': downloadUrl,
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
      appBar: AppBar(
        title: const Text('Sélectionnez une image'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null ? const Icon(Icons.account_circle, size: 150, color: Colors.grey) : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library, color: Colors.white,),
                  label: const Text('Choisir une image', style: TextStyle(color: Colors.white,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.blue,)
                    : ElevatedButton.icon(
                  onPressed: _uploadImage,
                  icon: const Icon(Icons.upload, color: Colors.blue,),
                  label: const Text('Enregistrer', style: TextStyle(color: Colors.blue,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}