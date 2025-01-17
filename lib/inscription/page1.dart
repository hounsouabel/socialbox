import 'package:flutter/material.dart';
import 'package:groupe7/inscription/page2.dart';

import '../home.dart';



class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
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
                      MaterialPageRoute(builder: (context) => MyHomePage())
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Rejoignez Chatterbox',
              style: TextStyle(fontSize: 30,  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Adjust radius as needed
                child: Image.asset(
                  'assets/c152cc1f10414675bcf2ac324984b408~tplv-rjxq75k7vb-image.png',
                  scale: 3,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Créez un compte pour communiquer avec vos proches et avec les communautés qui partagent vos centres d'intérêts",
              style: TextStyle(fontSize: 15, ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page2())
                );
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
                'Démarrer',
                style: TextStyle(),),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}