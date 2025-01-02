import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page5.dart';
import 'package:groupe7/inscription/page7.dart';
import 'package:groupe7/services/auth_service.dart';

class Page6 extends StatefulWidget {
  const Page6({super.key});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  bool _isObscure = true;
  bool _isLoading = false; // Ajout de l'état de chargement

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

  Future<void> _handlePass() async {
    final password = _passwordController.text;
    final validationResult = _validatePassword(password);

    if (validationResult == null) {
      if (inscriptionData.email.isEmpty ||
          inscriptionData.firstname.isEmpty ||
          inscriptionData.lastname.isEmpty ||
          inscriptionData.birthDate==null ||
          inscriptionData.gender==null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Certaines informations sont manquantes.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      AuthService authService = AuthService();
      try {
        await authService.signUpUser(
          email: inscriptionData.email,
          password: _passwordController.text,
          firstName: inscriptionData.firstname,
          lastName: inscriptionData.lastname,
          birthDate: inscriptionData.birthDate,
          gender: inscriptionData.gender,
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Page7()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                icon: Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page5()),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Créez un mot de passe',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Créez un mot de passe comprenant au moins 6 caractères.',
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
                      icon: Icon(Icons.lock, color: Colors.blue),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handlePass,
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
    );
  }
}
