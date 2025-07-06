import 'dart:ffi';

import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/insumo.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/providers/insumo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistroInsumoScreen extends StatefulWidget {
  final InsumoAgricola? insumo;

  const RegistroInsumoScreen({super.key, this.insumo});

  @override
  State<RegistroInsumoScreen> createState() => _RegistroInsumoScreenState();
}

class _RegistroInsumoScreenState extends State<RegistroInsumoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _tipoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _unidadMedidaController = TextEditingController();

  String? _tipoSeleccionado;
  String? _unidadMedidaSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.insumo != null) {
      _descripcionController.text = widget.insumo!.descripcion;
      _tipoController.text = widget.insumo!.tipo;
      _cantidadController.text = widget.insumo!.cantidad.toString();
      _unidadMedidaController.text = widget.insumo!.unidadMedida;
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _tipoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final insumoProvider = Provider.of<InsumoProvider>(
        context,
        listen: false,
      );

      if (widget.insumo == null) {
        // Crear nuevo Cultivo
        insumoProvider.addInsumo(
          InsumoAgricola(
            id: Uuid().v4(),
            descripcion: _descripcionController.text,
            tipo: _tipoController.text,
            cantidad: int.parse(_cantidadController.text),
            unidadMedida: _unidadMedidaController.text,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Insumo registrado')));
      } else {
        // Actualizar Cultivo existente
        widget.insumo!.descripcion = _descripcionController.text;
        widget.insumo!.tipo = _tipoController.text;
        widget.insumo!.cantidad = int.parse(_cantidadController.text);
        widget.insumo!.unidadMedida = _unidadMedidaController.text;

        insumoProvider.notifyListeners();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cultivo actualizado')));
      }

      Navigator.of(context).pop(); // Cierra la pantalla tras guardar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.insumo == null ? 'Registrar Insumo' : 'Editar Insumo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripcion',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el nombre' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Tipo de insumo',
                  border: OutlineInputBorder(),
                ),
                items: InsumoAgricola.tipos.map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _tipoSeleccionado = valor;
                    _tipoController.text = valor ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione un tipo de insumo';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cantidadController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese la cantidad'
                          : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _unidadMedidaSeleccionada,
                      decoration: InputDecoration(
                        labelText: 'Unidad',
                        border: OutlineInputBorder(),
                      ),
                      items: InsumoAgricola.unidadesMedida.map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(tipo),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        setState(() {
                          _unidadMedidaSeleccionada = valor;
                          _unidadMedidaController.text = valor ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleccione una unidad de medida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.insumo == null ? 'Registrar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
