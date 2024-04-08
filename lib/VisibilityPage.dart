import 'package:flutter/material.dart';

class VisibilityPage extends StatelessWidget {
  const VisibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visibilidad'),
      ),
      body: const Center(
        child: Text('Página de visibilidad'),
      ),
    );
  }
}
