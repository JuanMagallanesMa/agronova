import 'dart:ui';

import 'package:agronova/models/tarea.dart';
import 'package:agronova/providers/tarea_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareasCard extends StatelessWidget {
  final Tarea tareas;
  final VoidCallback? onView;


  const TareasCard({
    super.key,
    required this.tareas,
    this.onView,
    
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onView,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: tareas.estado,
                    onChanged: (bool? value) {
                      tareas.estado = value ?? false;
                      Provider.of<TareaProvider>(
                        context,
                        listen: false,
                      ).updateTarea(tareas);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tareas.nombre,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.description, tareas.descripcion),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.grass,
                          'Cultivo: ${tareas.cultivo.nombre}',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.date_range,
                          'Rango: ${_formatFecha(tareas.fechaInicio)} - ${_formatFecha(tareas.fechaFin)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
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

  String _formatFecha(DateTime fecha) {
    return fecha.toLocal().toString().split(' ')[0];
  }
}
