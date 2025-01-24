import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../inscription/inscription_data.dart';

class Personnal extends StatefulWidget {
  const Personnal({super.key});

  @override
  State<Personnal> createState() => _PersonnalState();
}

class _PersonnalState extends State<Personnal> {
  final formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? sexe;

  final List<String> genderOptions = ['Masculin', 'Féminin'];

  @override
  void initState() {
    super.initState();
    // Préremplir la date si une valeur existe
    if (inscriptionData.birthDate != null) {
      try {
        _selectedDate = inscriptionData.birthDate;
      } catch (e) {

        _selectedDate = null;
      }
    }

    if (genderOptions.contains(inscriptionData.gender)) {
      sexe = inscriptionData.gender;
    } else {
      sexe = null;
    }
  }

  /// Affiche le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations personnelles', style: TextStyle(fontSize: 20),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Indiquez vos informations personnelles, même si ce compte ne vous est pas dédié. Elles resteront confidentielles.'),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: const Text('Adresse e-mail'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true, // Empêche la saisie manuelle
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Date de naissance',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: sexe,
                      decoration: InputDecoration(
                        labelText: "Genre",
                        hintText: "Sélectionnez votre genre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),

                      ),
                      items: genderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          sexe = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner votre genre';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
