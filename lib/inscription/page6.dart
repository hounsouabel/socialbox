import 'package:flutter/material.dart';
import 'package:groupe7/inscription/page5.dart';
import 'package:groupe7/inscription/page7.dart';

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
      home: Page6(),
    );
  }
}

class Page6 extends StatefulWidget {
  const Page6({super.key});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  void _handlePass() {
    final password = _passwordController.text; // Assuming you have a TextEditingController
    final validationResult = _validatePassword(password);

    if (validationResult == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Page7()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationResult)),
      );
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
                icon: Icon(Icons.arrow_back, color: Colors.blue, size: 30,),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page5())
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Créez un mot de passe',
              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Créez unn mot de passe comprenant au moins 6 caractères.',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.blue,),
                      labelText: 'Mot de passe',
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
                    ),
                    validator: _validatePassword,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handlePass,
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