import 'package:flutter/material.dart';

class CancelarVenta extends StatelessWidget {
  const CancelarVenta({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelación'),
      ),
      body: const Center(
        child: Text('Página de cancelación'),
      ),
    );
  }
}
