import 'package:flutter/material.dart';

class PaginaCategorias extends StatelessWidget {
  const PaginaCategorias({super.key});

  final List<String> categorias = const [
    'Agricultores',
    'Cultivos',
    'Inventario Agricola',
    'Cultura',
    'Tarea de Riego y Fertilizacion',
    'Mercado y Ventas',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Categoría seleccionada: ${categorias[index]}'),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Center(
                child: Text(
                  categorias[index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
