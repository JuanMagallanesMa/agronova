import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/venta.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/providers/venta_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistroVentaScreen extends StatefulWidget {
  final Venta? venta;

  const RegistroVentaScreen({super.key, this.venta});

  @override
  State<RegistroVentaScreen> createState() => _RegistroVentaScreenState();
}

class _RegistroVentaScreenState extends State<RegistroVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _productosController = TextEditingController();
  final _totalController = TextEditingController();

  Map<Cultivo, int> _cantidadesSeleccionadas = {};

  @override
  void initState() {
    super.initState();
    if (widget.venta != null) {
      _nombreController.text = widget.venta!.nombre;
      _cedulaController.text = widget.venta!.cedula;
      _cantidadesSeleccionadas = Map.from(widget.venta!.cantidadesPorProducto);
      _productosController.text = _generarTextoProductos(
        _cantidadesSeleccionadas,
      );
      _totalController.text = calcularTotal().toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _productosController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  double calcularTotal() {
    return _cantidadesSeleccionadas.entries.fold(0.0, (sum, entry) {
      final cultivo = entry.key;
      final cantidad = entry.value;
      return sum + (cultivo.precioCaja * cantidad);
    });
  }

  String _generarTextoProductos(Map<Cultivo, int> datos) {
    return datos.entries
        .map((e) {
          final nombre = e.key.nombre;
          final precio = e.key.precioCaja.toStringAsFixed(2);
          return '$nombre (\$$precio) x${e.value}';
        })
        .join(', ');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_cantidadesSeleccionadas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona al menos un producto'),
          ),
        );
        return;
      }

      final ventaProvider = Provider.of<VentaProvider>(context, listen: false);

      final venta = Venta(
        id: widget.venta?.id ?? const Uuid().v4(),
        nombre: _nombreController.text.trim(),
        cedula: _cedulaController.text.trim(),
        cantidadesPorProducto: Map.from(_cantidadesSeleccionadas),
        total: calcularTotal(),
        cantidad: _cantidadesSeleccionadas.values.fold(0, (a, b) => a + b),
      );

      try {
        if (widget.venta == null) {
          await ventaProvider.addVenta(venta);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venta registrada con éxito')),
          );
        } else {
          await ventaProvider.updateVenta(venta);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venta actualizada correctamente')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la venta: $e')),
        );
      }
    }
  }

  Widget _buildForm() {
    final productoProvider = Provider.of<CultivoProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del cliente',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Por favor ingresa un nombre'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cedulaController,
            decoration: const InputDecoration(
              labelText: 'Cédula del cliente',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Por favor ingresa la cédula'
                : null,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _productosController,
            decoration: const InputDecoration(
              labelText: 'Productos',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final tempSeleccionados = Map<Cultivo, int>.from(
                _cantidadesSeleccionadas,
              );

              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Seleccionar productos'),
                    content: StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: productoProvider.cultivos.map((cultivo) {
                              final seleccionado = tempSeleccionados
                                  .containsKey(cultivo);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: Text(
                                      '${cultivo.nombre}, \$${cultivo.precioCaja.toStringAsFixed(2)}',
                                    ),
                                    value: seleccionado,
                                    onChanged: (selected) {
                                      setStateDialog(() {
                                        if (selected == true) {
                                          tempSeleccionados[cultivo] = 1;
                                        } else {
                                          tempSeleccionados.remove(cultivo);
                                        }
                                      });
                                    },
                                  ),
                                  if (seleccionado)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: DropdownButton<int>(
                                        value: tempSeleccionados[cultivo],
                                        onChanged: (value) {
                                          setStateDialog(() {
                                            tempSeleccionados[cultivo] = value!;
                                          });
                                        },
                                        items: List.generate(
                                          10,
                                          (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text('${index + 1} unds'),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _cantidadesSeleccionadas = Map.from(
                              tempSeleccionados,
                            );
                            _productosController.text = _generarTextoProductos(
                              _cantidadesSeleccionadas,
                            );
                            _totalController.text = calcularTotal()
                                .toStringAsFixed(2);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Total: \$${calcularTotal().toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(
              widget.venta == null ? 'Registrar Venta' : 'Actualizar Venta',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venta == null ? 'Registrar Venta' : 'Editar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: _buildForm()),
      ),
    );
  }
}
