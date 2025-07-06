import 'package:agronova/models/agricultor.dart';
import 'package:agronova/providers/agricultor_provider.dart';
import 'package:agronova/screens/agricultores/registro_agricultor.dart';
import 'package:agronova/widgets/cards/card_agricultores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaAgricultores extends StatefulWidget {
  const PaginaAgricultores({super.key});

  @override
  State<PaginaAgricultores> createState() => _PaginaAgricultoresState();
}

class _PaginaAgricultoresState extends State<PaginaAgricultores> {
  String _query = '';

  @override
  void initState() {
    super.initState();
  }

  Widget buildSearch() {
    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: 'Buscar por nombre',
      onChanged: (query) {
        setState(() {
          _query = query;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final agricultoresProvider = Provider.of<AgricultorProvider>(context);
    final agricultores = agricultoresProvider.searchAgricultores(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Agricultores'),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSearch(),
            const SizedBox(height: 16),
            Expanded(
              child: agricultores.isEmpty
                  ? const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No se encontraron agricultores'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: agricultores.length,
                      itemBuilder: (context, index) {
                        return AgricultorCard(
                          agricultor: agricultores[index],
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistroAgricultorScreen(
                                  agricultor: agricultores[index],
                                ),
                              ),
                            );
                            // Aquí puedes implementar la lógica para editar el agricultor
                          },
                          onDelete: () async {
                            final agricultor = agricultores[index];

                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar a "${agricultor.nombre}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              agricultoresProvider.deleteAgricultor(
                                agricultor.id!,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Agricultor eliminado correctamente',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistroAgricultorScreen(),
            ),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
