import 'package:flutter/material.dart';

class PaginaTareaRiegoFertilizacion extends StatelessWidget {
  const PaginaTareaRiegoFertilizacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea de Riego y Fertilización'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Aquí irá la funcionalidad de riego y fertilización.'),
      ),
    );
  }
}
