// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:groupe7/inscription/page7.dart';
import 'package:groupe7/services/auth_service.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isLoading = false;

  Future<void> _checkEmailVerified() async {
    setState(() {
      _isLoading = true;
    });

    try {
      AuthService authService = AuthService();
      await authService.reloadUser();

      if (authService.isEmailVerified()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Page7()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'e-mail n\'est pas encore vérifié.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() {
        _isLoading=false;
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      AuthService authService = AuthService();
      await authService.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un nouvel e-mail a été envoyé.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification de l\'e-mail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Veuillez vérifier votre adresse e-mail.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkEmailVerified,
                      child: const Text('Vérifier maintenant'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resendVerificationEmail,
                      child: const Text('Renvoyer l\'e-mail'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
