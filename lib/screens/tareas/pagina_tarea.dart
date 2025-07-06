import 'package:agronova/models/insumo.dart';
import 'package:agronova/models/tarea.dart';

import 'package:agronova/providers/insumo_provider.dart';
import 'package:agronova/providers/tarea_provider.dart';

import 'package:agronova/screens/inventario/registro_insumo.dart';
import 'package:agronova/screens/tareas/registro_tarea.dart';

import 'package:agronova/widgets/cards/card_insumos.dart';
import 'package:agronova/widgets/cards/card_tareas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaTarea extends StatefulWidget {
  const PaginaTarea({super.key});

  @override
  State<PaginaTarea> createState() => _PaginaTareaState();
}

class _PaginaTareaState extends State<PaginaTarea> {
  String _query = '';
  String _estadoSeleccionado = '';

  @override
  void initState() {
    super.initState();
  }

  void mostrarDialogoTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de la tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.title, 'Nombre: ${tarea.nombre}'),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.description,
                'Descripción: ${tarea.descripcion}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.grass, 'Cultivo: ${tarea.cultivo.nombre}'),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.date_range,
                'Inicio: ${tarea.fechaInicio.toLocal().toString().split(' ')[0]}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.event,
                'Fin: ${tarea.fechaFin.toLocal().toString().split(' ')[0]}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.people,
                'Agricultores: ${tarea.agricultores.isNotEmpty ? tarea.agricultores.map((a) => a.nombre).join(", ") : "Ninguno"}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.inventory,
                'Insumos: ${tarea.insumos.isNotEmpty ? tarea.insumos.map((i) => i.descripcion).join(", ") : "Ninguno"}',
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(); // Cierra el diálogo antes de navegar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegistroTareaScreen(tarea: tarea),
                        ),
                      );
                    },
                    child: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: Text(
                            '¿Estás seguro de que deseas eliminar a "${tarea.descripcion}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
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
                        final tareaProvider = Provider.of<TareaProvider>(
                          context,
                          listen: false,
                        );
                        tareaProvider.deleteTarea(tarea.id!);
                        Navigator.of(
                          context,
                        ).pop(); // Cierra el diálogo principal después de eliminar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarea eliminada correctamente'),
                          ),
                        );
                      }
                    },
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildSearch() {
    return Center(
      child: Column(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Buscar por nombre de tarea',
            onChanged: (query) {
              setState(() {
                _query = query;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(Tarea.estados.length, (index) {
              final estado = Tarea.estados[index];
              return ChoiceChip(
                label: Text(estado),
                selected: _estadoSeleccionado == estado,
                onSelected: (selected) {
                  setState(() {
                    _estadoSeleccionado = selected ? estado : '';
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
    final tareaProvider = Provider.of<TareaProvider>(context);
    final tareas = tareaProvider.searchTarea(_query, _estadoSeleccionado);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Tareas'),
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
              child: tareas.isEmpty
                  ? const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No se encontraron tareas'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        return TareasCard(
                          tareas: tareas[index],
                          onView: () {
                            mostrarDialogoTarea(context, tareas[index]);
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
              builder: (context) => const RegistroTareaScreen(),
            ),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
