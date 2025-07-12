import 'package:agronova/models/agricultor.dart';
import 'package:agronova/models/cultivo.dart';
import 'package:agronova/providers/agricultor_provider.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/screens/agricultores/registro_agricultor.dart';
import 'package:agronova/screens/cultivos/registro_cultivo.dart';
import 'package:agronova/widgets/cards/card_agricultores.dart';
import 'package:agronova/widgets/cards/card_cultivos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaCultivos extends StatefulWidget {
  const PaginaCultivos({super.key});

  @override
  State<PaginaCultivos> createState() => _PaginaCultivosState();
}

class _PaginaCultivosState extends State<PaginaCultivos> {
  String _query = '';
  String _categoriaSeleccionada = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CultivoProvider>(context, listen: false).fetchCultivos();
    });
  }

  Widget buildSearch() {
    return Center(
      child: Column(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Buscar por nombre',
            onChanged: (query) {
              setState(() {
                _query = query;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(Cultivo.categorias.length, (index) {
              final categoria = Cultivo.categorias[index];
              return ChoiceChip(
                label: Text(categoria),
                selected: _categoriaSeleccionada == categoria,
                onSelected: (selected) {
                  setState(() {
                    _categoriaSeleccionada = selected ? categoria : '';
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cultivoProvider = Provider.of<CultivoProvider>(context);
    final cultivos = cultivoProvider.searchCultivo(
      _query,
      _categoriaSeleccionada,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Cultivos'),
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
              child: cultivos.isEmpty
                  ? const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No se encontraron cultivos'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: cultivos.length,
                      itemBuilder: (context, index) {
                        return CultivoCard(
                          cultivo: cultivos[index],
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistroCultivoScreen(
                                  cultivo: cultivos[index],
                                ),
                              ),
                            );
                            // Aquí puedes implementar la lógica para editar el agricultor
                          },
                          onDelete: () async {
                            final cultivo = cultivos[index];

                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar "${cultivo.nombre}"?',
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
                              cultivoProvider.deleteCultivo(cultivo.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cultivo eliminado correctamente',
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
              builder: (context) => const RegistroCultivoScreen(),
            ),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
