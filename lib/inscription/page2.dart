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

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //Remplissage auto.
    firstnameController.text = inscriptionData.firstname;
    lastnameController.text = inscriptionData.lastname;
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
                icon: Icon(Icons.arrow_back, color: Colors.blue, size: 30,),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page1())
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Comment vous appellez-vous ?',
              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Entrez le nom complet que vous utilisez au quotidien.',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            Form(
              key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                        ),
                        validator: (String? value) {
                          return value == null || value == "" ? "Ce champ est obligatoire" : null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: lastnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                        ),
                        validator: (String? value) {
                          return value == null || value == "" ? "Ce champ est obligatoire" : null;
                        },
                      ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  inscriptionData.firstname = firstnameController.text;
                  inscriptionData.lastname = lastnameController.text;
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page3())
                    );
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue
              ),
              child: Text(
                'Suivant',
                style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}