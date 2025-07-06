import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agronova/models/cultivo.dart';

class CultivoCard extends StatelessWidget {
  final Cultivo cultivo;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CultivoCard({
    super.key,
    required this.cultivo,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'es_MX',
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                      cultivo.nombre,
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
              _buildInfoRow(Icons.category, 'Categoría: ${cultivo.categoria}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today, 
                  'Fecha inicio: ${dateFormat.format(cultivo.fechaInicio)}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, 'Ubicación: ${cultivo.ubicacion}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.attach_money, 
                  'Precio: ${currencyFormat.format(cultivo.precioCaja)}'),
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
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}