import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaginaAcercaDe extends StatelessWidget {
  const PaginaAcercaDe({super.key});

  Future<List<dynamic>> _leerJson() async {
    final String respuesta = await rootBundle.loadString(
      'assets/datos_acerca.json',
    );
    return json.decode(respuesta);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _leerJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card 1: Título + Objetivos
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['titulo'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Objetivos del proyecto:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...item['objetivos'].map<Widget>(
                            (obj) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text("- $obj"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Card 2: Integrantes
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Integrantes:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...item['integrantes'].map<Widget>(
                            (nombre) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text("• $nombre"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los datos."));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
