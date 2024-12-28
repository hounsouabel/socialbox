import 'package:flutter/material.dart';
import 'package:groupe7/inscription/page1.dart';
import 'login.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(_isPressed ? 20.0 : 10.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
          });
        },
        style: ElevatedButton.styleFrom(
          iconColor: Colors.transparent, // Pour ne pas avoir de couleur de fond
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Pour que le bouton suive la forme du container
          ),
        ),
        child: Text('Cliquer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/Chatterbox-removebg-preview.png',
                  scale: 3,
                ),
              ),
              SizedBox(height: 60),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.blue),
                    bottom: BorderSide(color: Colors.blue),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chatterbox demande et reçoit votre email par votre réseau mobile.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/home.png',
                      scale: (1),
                    ),
                  ),
                  Text(
                    'Bienvenue sur ChatterBox 👋',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyLoginPage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                        'Se connecter',
                        style: TextStyle(color: Colors.blue),),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Page1())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                        'Créer un compte',
                        style: TextStyle(color: Colors.pink),),
                  ),
                ],
              )// Add some space before the buttons
            ],
          ),
        ),
      ),
    );
  }
}