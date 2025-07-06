import 'package:agronova/models/agricultor.dart';
import 'package:agronova/providers/agricultor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgricultorCard extends StatelessWidget {
  final Agricultor agricultor;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AgricultorCard({
    super.key,
    required this.agricultor,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onView,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      agricultor.nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          color: Colors.orange[600],
                          onPressed: onEdit,
                          tooltip: 'Editar',
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: Colors.red[600],
                          onPressed: onDelete,
                          tooltip: 'Eliminar',
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.person_outline,
                'Edad: ${agricultor.edad} años',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, 'Zona: ${agricultor.zona}'),
              if (agricultor.experiencia != null &&
                  agricultor.experiencia!.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.work,
                      'Experiencia: ${agricultor.experiencia}',
                    ),
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
}
