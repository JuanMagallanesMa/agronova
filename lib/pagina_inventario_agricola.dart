import 'package:flutter/material.dart';

class PaginaInventarioAgricola extends StatelessWidget {
  const PaginaInventarioAgricola({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario Agrícola'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Aquí irá la funcionalidad de inventario agrícola.'),
      ),
    );
  }
}
