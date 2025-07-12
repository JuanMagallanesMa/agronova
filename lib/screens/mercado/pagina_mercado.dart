import 'package:agronova/models/venta.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/providers/venta_provider.dart';
import 'package:agronova/screens/mercado/registro_venta.dart';
import 'package:agronova/widgets/cards/card_ventas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaMercado extends StatefulWidget {
  const PaginaMercado({super.key});

  @override
  State<PaginaMercado> createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {
  String _query = '';
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final cultivoProvider = Provider.of<CultivoProvider>(
        context,
        listen: false,
      );
      final ventaProvider = Provider.of<VentaProvider>(context, listen: false);

      // 1. Carga los cultivos desde Firestore
      if (cultivoProvider.cultivos.isEmpty) {
        await cultivoProvider.fetchCultivos();
      }

      // 2. Carga las ventas con los cultivos disponibles
      await ventaProvider.cargarVentas(cultivoProvider.cultivos);
    });
  }

  void mostrarDialogoVenta(BuildContext context, Venta venta) {
    showDialog(
      context: context,
      builder: (context) {
        final productosTexto = venta.cantidadesPorProducto.entries
            .map((entry) {
              final nombre = entry.key.nombre;
              final precio = entry.key.precioCaja.toStringAsFixed(2);
              final cantidad = entry.value;
              return '$nombre (\$$precio) x$cantidad';
            })
            .join(', ');

        return AlertDialog(
          title: const Text('Detalles de la venta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.person, 'Nombre: ${venta.nombre}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.info, 'Cédula: ${venta.cedula}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.shopping_cart, 'Productos: $productosTexto'),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.attach_money,
                'Total: \$${venta.total.toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegistroVentaScreen(venta: venta),
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
                            '¿Estás seguro de que deseas eliminar la venta de "${venta.nombre}" por \$${venta.total.toStringAsFixed(2)}?',
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
                        final ventaProvider = Provider.of<VentaProvider>(
                          context,
                          listen: false,
                        );
                        ventaProvider.deleteVenta(venta.id!);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Venta eliminada correctamente'),
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
            hintText: 'Buscar por cédula del cliente',
            onChanged: (query) {
              setState(() {
                _query = query;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ventaProvider = Provider.of<VentaProvider>(context);
    final ventas = ventaProvider.searchVentas(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Ventas'),
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
              child: ventas.isEmpty
                  ? const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No se encontraron ventas'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: ventas.length,
                      itemBuilder: (context, index) {
                        return VentasCard(
                          ventas: ventas[index],
                          onView: () {
                            mostrarDialogoVenta(context, ventas[index]);
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
              builder: (context) => const RegistroVentaScreen(),
            ),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
