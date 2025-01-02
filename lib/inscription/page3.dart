import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page2.dart';
import 'package:groupe7/inscription/page4.dart';



class Page3 extends StatefulWidget {
  
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

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
      backgroundColor: Colors.pink[30],
      body: Padding(
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
                    MaterialPageRoute(builder: (context) => Page2()),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quelle est votre date de naissance ?',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Choisissez votre date de naissance. Mettez vos proches au courant de votre date de naissance pour recevoir de petits gestes',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true, // Empêche la saisie manuelle
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_month, color: Colors.blue),
                      labelText: _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : 'Date de naissance',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Convertir la date sélectionnée en chaîne ISO8601 avant de sauvegarder
                if (_selectedDate != null) {
                  inscriptionData.birthDate = _selectedDate!;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page4()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez sélectionner une date de naissance'),
                    ),
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
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
