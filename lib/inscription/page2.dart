import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page1.dart';
import 'package:groupe7/inscription/page3.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final pseudoController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Remplissage auto.
    firstnameController.text = inscriptionData.firstname;
    lastnameController.text = inscriptionData.lastname;
    pseudoController.text = inscriptionData.pseudo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[30],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Page1()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comment vous appelez-vous ?',
                style: TextStyle(fontSize: 30,  fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Entrez le nom complet que vous utilisez au quotidien.',
                style: TextStyle(fontSize: 15, ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstnameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                            ),
                            validator: (String? value) {
                              return (value == null || value.isEmpty) ? "Ce champ est obligatoire" : null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: lastnameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                            ),
                            validator: (String? value) {
                              return (value == null || value.isEmpty) ? "Ce champ est obligatoire" : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Entrez votre pseudonyme. Il servira à vous reconnaître.',
                      style: TextStyle(fontSize: 15, ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: pseudoController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Pseudo',
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? "Ce champ est obligatoire" : null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    inscriptionData.firstname = firstnameController.text;
                    inscriptionData.lastname = lastnameController.text;
                    inscriptionData.pseudo = pseudoController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Page3()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Suivant',
                  style: TextStyle(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
