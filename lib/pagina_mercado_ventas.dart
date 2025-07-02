import 'package:flutter/material.dart';

class PaginaMercadoVentas extends StatelessWidget {
  const PaginaMercadoVentas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercado y Ventas'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Aquí irá la funcionalidad de mercado y ventas.'),
      ),
    );
  }
}
