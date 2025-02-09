import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/screens/personnal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.fromStringUrl('cloudinary://837771674223148:9mnsJFyFSNRI7SsT3kPcgSpwSPY@davhr8fip');

  File? _image;
  String? _currentImageUrl;
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDoc = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (userDoc.exists) {
      setState(() {
        _firstNameController.text = userDoc['firstName'] ?? '';
        _lastNameController.text = userDoc['lastName'] ?? '';
        _pseudoController.text = userDoc['pseudo'] ?? '';
        _bioController.text = userDoc['bio'] ?? '';
        _currentImageUrl = userDoc['profil'];
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      String? imageUrl = _currentImageUrl;

      if (_image != null) {
        final response = await _cloudinary.uploader().upload(
          _image!,
          params: UploadParams(
            publicId: _auth.currentUser!.uid,
            overwrite: true,
            resourceType: 'image',
          ),
        );

        imageUrl = response?.data?.secureUrl;
        if (imageUrl == null) throw Exception('Échec de l\'upload Cloudinary');
      }

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'pseudo': _pseudoController.text,
        'bio': _bioController.text,
        if (imageUrl != null) 'profil': imageUrl,
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _ProfileImageSection(
              image: _image,
              currentImageUrl: _currentImageUrl,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 30),
            _ProfileForm(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              pseudoController: _pseudoController,
              bioController: _bioController,
            ),
            _PersonalSettingsButton(),
          ],
        ),
      ),

    );
  }
}

class _ProfileImageSection extends StatelessWidget {
  final File? image;
  final String? currentImageUrl;
  final Function(ImageSource) onPickImage;

  const _ProfileImageSection({
    required this.image,
    required this.currentImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _getImage(),
          backgroundColor: Colors.grey[200],
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.photo_camera, size: 20, color: Colors.white),
          ),
          onPressed: () => _showImagePicker(context),
        ),
      ],
    );
  }

  ImageProvider? _getImage() {
    if (image != null) return FileImage(image!);
    if (currentImageUrl?.isNotEmpty ?? false) return NetworkImage(currentImageUrl!);
    return const AssetImage('assets/person.png');
  }

  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Source de l\'image'),
        children: [
          _ImageSourceOption(
            icon: Icons.camera_alt,
            label: 'Appareil photo',
            onTap: () => onPickImage(ImageSource.camera),
          ),
          _ImageSourceOption(
            icon: Icons.photo_library,
            label: 'Galerie',
            onTap: () => onPickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        onTap();
      },
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController pseudoController;
  final TextEditingController bioController;

  const _ProfileForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.pseudoController,
    required this.bioController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _ProfileTextField(
            controller: firstNameController,
            label: 'Prénom',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _ProfileTextField(
            controller: lastNameController,
            label: 'Nom',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _ProfileTextField(
            controller: pseudoController,
            label: 'Pseudo',
            icon: Icons.alternate_email,
          ),
          const SizedBox(height: 16),
          _BioTextField(controller: bioController),
        ],
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _BioTextField extends StatelessWidget {
  final TextEditingController controller;

  const _BioTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      maxLength: 150,
      decoration: InputDecoration(
        labelText: 'Bio',
        prefixIcon: const Icon(Icons.edit),
        border: const OutlineInputBorder(),
        counterText: '${150 - controller.text.length} caractères restants',
      ),
    );
  }
}

class _PersonalSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Personnal()),
      ),
      child: const Text(
        'Paramètres des informations personnelles',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }
}