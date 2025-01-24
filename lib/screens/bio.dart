import 'package:flutter/material.dart';

class Bio extends StatefulWidget {
  const Bio({super.key});

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false; // Indicateur pour montrer si on est en train d'enregistrer

  void _saveBio() {
    setState(() {
      _isSaving = true;
    });

    if (_formKey.currentState!.validate()) {
      // Ici, vous mettriez en place votre logique pour enregistrer la bio
      // Par exemple, envoyer les données à un serveur
      print('Bio enregistrée : ${controller.text}');

      // Réinitialiser le formulaire après l'enregistrement
      controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bio enregistrée avec succès !')),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveBio,
            child: Text(
              'Enregistrer',
              style: TextStyle(color: Colors.blue),
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
                  keyboardType: TextInputType.text,
                  maxLength: 150,
                  validator: (value) {
                    if (value!.length > 150) {
                      return 'Veuillez ne pas dépasser 150 caractères.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Écrivez quelque chose à propos de vous...',
                    counterText: '${controller.text.length}/150',
                  ),
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}