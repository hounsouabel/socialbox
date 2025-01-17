import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page3.dart';
import 'package:groupe7/inscription/page5.dart';



class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final formKey = GlobalKey<FormState>();
  String? sexe;

  final List<String> genderOptions = ['Masculin', 'Féminin'];

  @override
  void initState() {
    super.initState();
    // Vérifie si la valeur initiale est dans les options du dropdown
    if (genderOptions.contains(inscriptionData.gender)) {
      sexe = inscriptionData.gender;
    } else {
      sexe = null; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[30],
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 45),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page3()),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Quel est votre genre ?',
                style: TextStyle(
                  fontSize: 30,
                  
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Cochez le sexe auquel vous appartenez.',
                style: TextStyle(fontSize: 15, ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
              
                value: sexe,
                decoration: InputDecoration(
                  icon: Icon(Icons.transgender, color: Colors.blue),
                  labelText: "Genre",
                  hintText: "Sélectionnez votre genre",
                  
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    inscriptionData.gender = sexe;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page5()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Suivant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
