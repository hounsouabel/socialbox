import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter( // Assure-toi que ce soit bien un Sliver !
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Erreur : $error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
