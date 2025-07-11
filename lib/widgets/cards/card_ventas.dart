import 'package:agronova/models/venta.dart';
import 'package:flutter/material.dart';

class VentasCard extends StatelessWidget {
  final Venta ventas;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VentasCard({
    super.key,
    required this.ventas,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Protegemos cantidadesPorProducto contra null
    final cantidadesPorProducto = ventas.cantidadesPorProducto ?? {};

    // Construir texto de productos con cantidad y precio
    final productosTexto = cantidadesPorProducto.entries
        .map((entry) {
          final nombre = entry.key.nombre;
          final precio = entry.key.precioCaja.toStringAsFixed(2);
          final cantidad = entry.value;
          return '$nombre (\$$precio) x$cantidad';
        })
        .join(', ');

    final cantidadTotal = cantidadesPorProducto.values.fold<int>(
      0,
      (sum, val) => sum + val,
    );

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
                      ventas.nombre,
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

              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, 'Nombre: ${ventas.nombre}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.badge, 'Cédula: ${ventas.cedula}'),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.shopping_cart,
                productosTexto.isNotEmpty
                    ? 'Productos: $productosTexto'
                    : 'Productos: Ninguno',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.format_list_numbered,
                'Cantidad total: $cantidadTotal',
              ),

              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.attach_money,
                'Total: \$${ventas.total.toStringAsFixed(2)}',
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
