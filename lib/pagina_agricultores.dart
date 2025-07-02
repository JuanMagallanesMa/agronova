import 'package:flutter/material.dart';

class PaginaAgricultores extends StatelessWidget {
  const PaginaAgricultores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Agricultores'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Aquí irá la funcionalidad para agricultores.'),
      ),
    );
  }
}
