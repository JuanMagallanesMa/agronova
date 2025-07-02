import 'package:flutter/material.dart';

class PaginaCultivos extends StatelessWidget {
  const PaginaCultivos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Cultivos'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Aquí irá la funcionalidad de gestión de cultivos.'),
      ),
    );
  }
}
