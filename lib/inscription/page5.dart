import 'package:flutter/material.dart';
import 'package:groupe7/inscription/inscription_data.dart';
import 'package:groupe7/inscription/page4.dart';
import 'package:groupe7/inscription/page6.dart';


class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {

  //final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un e-mail valide';
    }
    return null;
  }

  void _handleEmail() {
    inscriptionData.email=_emailController.text;
    final email = _emailController.text; 
    final validationResult = _validateEmail(email);

    if (validationResult == null) {
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Page6()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationResult)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text=inscriptionData.email;

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
                      MaterialPageRoute(builder: (context) => Page4())
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quel est votre e-mail ?',
              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Entrez l\'adresse e-mail où vous joindre. Personne ne le verra sur votre profil',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail, color: Colors.blue,),
                      labelText: 'Email',
                    ),
                    validator: _validateEmail,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Vous recevrez des e-mails de notre part et pouvez à tout moment les désactiver',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleEmail,
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