import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bio extends StatefulWidget {
  final String userId;
  const Bio({super.key, required this.userId});

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _saveBio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'bio': controller.text,
        'lastUpdate': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bio mise à jour avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSaving ? null : () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveBio,
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: _isSaving ? Colors.grey : Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  maxLines: 5,
                  maxLength: 150,
                  decoration: InputDecoration(
                    labelText: 'Écrivez quelque chose à propos de vous...',
                    border: const OutlineInputBorder(),
                    counterText: '${controller.text.length}/150',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ce champ est requis';
                    if (value!.length > 150) {
                      return '150 caractères maximum';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}