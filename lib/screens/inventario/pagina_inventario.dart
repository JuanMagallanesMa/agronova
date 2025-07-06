import 'package:agronova/models/insumo.dart';

import 'package:agronova/providers/insumo_provider.dart';

import 'package:agronova/screens/cultivos/registro_cultivo.dart';
import 'package:agronova/screens/inventario/registro_insumo.dart';

import 'package:agronova/widgets/cards/card_insumos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaInventario extends StatefulWidget {
  const PaginaInventario({super.key});

  @override
  State<PaginaInventario> createState() => _PaginaInventarioState();
}

class _PaginaInventarioState extends State<PaginaInventario> {
  String _query = '';
  String _tipoSeleccionado = '';

  @override
  void initState() {
    super.initState();
  }

  Widget buildSearch() {
    return Center(
      child: Column(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Buscar por descripcion',
            onChanged: (query) {
              setState(() {
                _query = query;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(InsumoAgricola.tipos.length, (
              index,
            ) {
              final tipo = InsumoAgricola.tipos[index];
              return ChoiceChip(
                label: Text(tipo),
                selected: _tipoSeleccionado == tipo,
                onSelected: (selected) {
                  setState(() {
                    _tipoSeleccionado = selected ? tipo : '';
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
    final insumoProvider = Provider.of<InsumoProvider>(context);
    final insumos = insumoProvider.searchInsumo(_query, _tipoSeleccionado);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario Agrícola'),
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
              child: insumos.isEmpty
                  ? const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No se encontraron cultivos'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: insumos.length,
                      itemBuilder: (context, index) {
                        return InsumoCard(
                          insumo: insumos[index],
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistroInsumoScreen(
                                  insumo: insumos[index],
                                ),
                              ),
                            );
                          },
                          onDelete: () async {
                            final insumo = insumos[index];

                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar a "${insumo.descripcion}"?',
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
                              insumoProvider.deleteInsumo(insumo.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Insumo eliminado correctamente',
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
              builder: (context) => const RegistroInsumoScreen(),
            ),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
