import 'package:flutter/material.dart';
import 'package:groupe7/inscription/page3.dart';
import 'package:groupe7/inscription/page5.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Page4(),
    );
  }
}

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  final formKey = GlobalKey<FormState>();
  String? sexe;

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
                      MaterialPageRoute(builder: (context) => Page3())
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quel est votre genre ?',
              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Cochez le sexe auquel vous appartenez.',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.transgender, color: Colors.blue,),
                    label: Text("Genre"),
                    hintText: "Sélectionnez votre genre"
                ),
                items: [
                  DropdownMenuItem(
                    child: Text('Masculin'),
                    value: 'Masculin',
                  ),
                  DropdownMenuItem(
                    child: Text('Féminin'),
                    value: 'Féminin',
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    sexe = value;
                  });
                },
                validator: (String? value) {
                  return value == null || value == "" ? "Ce champ est obligatoire" : null;
                },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page5())
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
                style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}