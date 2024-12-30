import 'package:flutter/material.dart';
import 'package:groupe7/chatterbox.dart';
import 'package:groupe7/home.dart';
import 'inscription/page1.dart';

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
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un e-mail valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Page1()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez corriger les erreurs avant de continuer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.pink, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo-removebg-preview.png',
                      scale: 3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mot de passe',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: _validatePassword,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.pink
              ),
              child: Text(
                'Se connecter',
                style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatterBox())
                );
              },
              child: Text(
                'Mot de passe oublié ?',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page1())
                );
              },
              child: Text(
                'Créer un compte',
                style: TextStyle(color: Colors.pink),
              ),
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.pink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),

              ),
            ),


          ],
        ),
      ),
    );
  }
}