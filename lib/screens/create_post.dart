import 'dart:io';

import 'package:groupe7/utilities/utils.dart';
import 'package:groupe7/widgets/round_button.dart';
import 'package:groupe7/widgets/image_video_view.dart';
import 'package:groupe7/widgets/profile_info.dart';
import 'package:groupe7/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:uuid/uuid.dart';

import 'package:groupe7/utilities/utils.dart';
import 'package:groupe7/widgets/round_button.dart';
import 'package:groupe7/widgets/image_video_view.dart';
import 'package:groupe7/widgets/profile_info.dart';
//import 'package:groupe7/providers/posts_provider.dart';

import 'home_page.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late final TextEditingController _postController;
  File? file;
  String fileType = 'image';
  bool isLoading = false;

  final cloudinary = Cloudinary.fromStringUrl(
      'cloudinary://837771674223148:9mnsJFyFSNRI7SsT3kPcgSpwSPY@davhr8fip');

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> uploadFile(String fileName) async {
    if (file == null) return; // Vérifiez si le fichier est sélectionné

    setState(() {
      isLoading = true; // Indique que le téléchargement est en cours
    });

    try {
      // Générer un UUID
      var uuid = Uuid();
      String publicId = uuid.v4(); // Générer un nouvel UUID

      var response = await cloudinary.uploader().upload(
        File(file!.path),
        params: UploadParams(
          filename: fileName,
          publicId: publicId, // Utiliser l'UUID comme publicId
          uniqueFilename: false,
          overwrite: false,
        ),
      );

      print("Succès ${response?.data?.publicId}");
      print(response?.data?.secureUrl);
    } catch (e) {
      print('Erreur lors du téléchargement : $e');
    } finally {
      setState(() {
        isLoading = false; // Réinitialisez l'état de chargement
      });
    }
  }

  Future<void> makePost() async {
    if (isLoading || file == null) return;

  setState(() => isLoading = true);
  try {
    await ref.read(globalProvider).makePost(
      content: _postController.text,
      file: file!,
      postType: fileType,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ChatterBox()),
          (Route<dynamic> route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la création du post : $e')),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*actions: [
          TextButton(
            onPressed: makePost,
            child: const Text(
              'PUBLIER',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileInfo(),
              const SizedBox(height: 20),
              TextField(
                controller: _postController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: 'À quoi pensez-vous?',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15.0),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              file != null
                  ? ImageVideoView(
                file: file!,
                fileType: fileType,
              )
                  : PickFileWidget(
                pickImage: () async {
                  fileType = 'image';
                  file = await pickImage();
                  setState(() {});
                },
                pickVideo: () async {
                  fileType = 'video';
                  file = await pickVideo();
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Center(
                child: RoundButton(
                  onPressed: file != null
                      ? () {
                    makePost();
                    //uploadFile(file!.path.split('/').last);
                  }
                      : null, // Désactivez le bouton si le fichier est nul
                  label: 'PUBLIER',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickFileWidget extends StatelessWidget {
  const PickFileWidget({
    super.key,
    required this.pickImage,
    required this.pickVideo,
  });

  final VoidCallback pickImage;
  final VoidCallback pickVideo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Sélectionner une image'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: pickVideo,
          icon: const Icon(Icons.videocam),
          label: const Text('Sélectionner une vidéo'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}