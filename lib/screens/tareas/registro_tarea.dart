import 'dart:ffi';

import 'package:agronova/models/agricultor.dart';
import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/insumo.dart';
import 'package:agronova/models/tarea.dart';
import 'package:agronova/providers/agricultor_provider.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/providers/insumo_provider.dart';
import 'package:agronova/providers/tarea_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistroTareaScreen extends StatefulWidget {
  final Tarea? tarea;

  const RegistroTareaScreen({super.key, this.tarea});

  @override
  State<RegistroTareaScreen> createState() => _RegistroTareaScreenState();
}

class _RegistroTareaScreenState extends State<RegistroTareaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _cultivoController = TextEditingController();
  final _agricultoresController = TextEditingController();
  final _insumosController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();

  Cultivo? _cultivoSeleccionado;
  DateTime? _fechaInicioSeleccionada;
  DateTime? _fechaFinSeleccionada;
  List<Agricultor> _agricultoresSeleccionados = [];
  List<InsumoAgricola> _insumosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    if (widget.tarea != null) {
      _nombreController.text = widget.tarea!.nombre;
      _descripcionController.text = widget.tarea!.descripcion;
      _cultivoSeleccionado = widget.tarea!.cultivo;
      _fechaInicioSeleccionada = widget.tarea!.fechaInicio;
      _fechaFinSeleccionada = widget.tarea!.fechaFin;

      _fechaInicioController.text = widget.tarea!.fechaInicio
          .toIso8601String()
          .split('T')
          .first;
      _fechaFinController.text = widget.tarea!.fechaFin
          .toIso8601String()
          .split('T')
          .first;
      _agricultoresController.text = widget.tarea!.agricultores
          .map((a) => a.nombre)
          .join(', ');
      _insumosController.text = widget.tarea!.insumos
          .map((i) => i.descripcion)
          .join(', ');
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cultivoController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    _agricultoresController.dispose();
    _insumosController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tareaProvider = Provider.of<TareaProvider>(context, listen: false);

      if (_cultivoSeleccionado == null) {
        // Mostrar mensaje de error, no continuar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona un cultivo')),
        );
        return;
      }
      if (_fechaInicioSeleccionada == null) {
        // Mostrar mensaje de error, no continuar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona una fecha de inicio')),
        );
        return;
      }
      if (_fechaFinSeleccionada == null) {
        // Mostrar mensaje de error, no continuar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona una fecha de fin')),
        );
        return;
      }
      if (_agricultoresSeleccionados.isEmpty) {
        // Mostrar mensaje de error, no continuar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor selecciona al menos un agricultor'),
          ),
        );
        return;
      }
      if (_insumosSeleccionados.isEmpty) {
        // Mostrar mensaje de error, no continuar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona al menos un insumo')),
        );
        return;
      }
      final nuevaTarea = Tarea(
        id: widget.tarea?.id ?? const Uuid().v4(),
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        cultivo: _cultivoSeleccionado!,
        fechaInicio: _fechaInicioSeleccionada!,
        fechaFin: _fechaFinSeleccionada!,
        agricultores: _agricultoresSeleccionados,
        insumos: _insumosSeleccionados,
      );
      if (widget.tarea == null) {
        // Registro nuevo
        tareaProvider.addTarea(nuevaTarea);
      } else {
        // Edición
        tareaProvider.updateTarea(nuevaTarea);
      }

      Navigator.pop(context);
    }
  }

  Widget _buildForm() {
    final cultivoProvider = Provider.of<CultivoProvider>(context);
    final agricultorProvider = Provider.of<AgricultorProvider>(context);
    final insumoProvider = Provider.of<InsumoProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la tarea',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _cultivoSeleccionado,
                hint: Text('Selecciona un cultivo'),
                decoration: InputDecoration(
                  labelText: 'Cultivo',
                  border: OutlineInputBorder(),
                ),
                items: cultivoProvider.cultivos.map((cultivo) {
                  return DropdownMenuItem<Cultivo>(
                    value: cultivo,
                    child: Text('${cultivo.nombre} - ${cultivo.fechaInicio}'),
                  );
                }).toList(),
                onChanged: (Cultivo? nuevoCultivo) {
                  setState(() {
                    _cultivoSeleccionado = nuevoCultivo;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fechaInicioController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Inicio',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate:
                              _fechaInicioSeleccionada ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (fecha != null) {
                          setState(() {
                            _fechaInicioSeleccionada = fecha;
                            _fechaInicioController.text = fecha
                                .toIso8601String()
                                .split('T')
                                .first;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _fechaFinController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Fin',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: _fechaFinSeleccionada ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (fecha != null) {
                          setState(() {
                            _fechaFinSeleccionada = fecha;
                            _fechaFinController.text = fecha
                                .toIso8601String()
                                .split('T')
                                .first;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _agricultoresController,
                decoration: const InputDecoration(
                  labelText: 'Agricultores',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  List<Agricultor> tempSeleccionados = [
                    ..._agricultoresSeleccionados,
                  ];

                  final seleccionados = await showDialog<List<Agricultor>>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Seleccionar Agricultores'),
                        content: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: agricultorProvider.agricultores.map((
                                  agric,
                                ) {
                                  final seleccionado = tempSeleccionados
                                      .contains(agric);
                                  return CheckboxListTile(
                                    title: Text(agric.nombre),
                                    value: seleccionado,
                                    onChanged: (bool? selected) {
                                      setStateDialog(() {
                                        if (selected == true) {
                                          tempSeleccionados.add(agric);
                                        } else {
                                          tempSeleccionados.remove(agric);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, tempSeleccionados),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (seleccionados != null) {
                    setState(() {
                      _agricultoresSeleccionados = seleccionados;
                      _agricultoresController.text = seleccionados
                          .map((a) => a.nombre)
                          .join(', ');
                    });
                  }
                },
              ),

              SizedBox(height: 16),

              TextField(
                controller: _insumosController,
                decoration: const InputDecoration(
                  labelText: 'Insumos',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  List<InsumoAgricola> tempSeleccionados = [
                    ..._insumosSeleccionados,
                  ];

                  final seleccionados = await showDialog<List<InsumoAgricola>>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Seleccionar Insumos'),
                        content: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: insumoProvider.insumos.map((agric) {
                                  final seleccionado = tempSeleccionados
                                      .contains(agric);
                                  return CheckboxListTile(
                                    title: Text(
                                      '${agric.tipo} - ${agric.descripcion} (${agric.cantidad} ${agric.unidadMedida})',
                                    ),
                                    value: seleccionado,
                                    onChanged: (bool? selected) {
                                      setStateDialog(() {
                                        if (selected == true) {
                                          tempSeleccionados.add(agric);
                                        } else {
                                          tempSeleccionados.remove(agric);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, tempSeleccionados),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (seleccionados != null) {
                    setState(() {
                      _insumosSeleccionados = seleccionados;
                      _insumosController.text = seleccionados
                          .map(
                            (a) =>
                                '${a.descripcion} (${a.cantidad} ${a.unidadMedida})',
                          )
                          .join(', ');
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              // Aquí puedes agregar los widgets para seleccionar agricultores e insumos
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.tarea == null ? 'Registrar Tarea' : 'Actualizar Tarea',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarea == null ? 'Registrar Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(children: [_buildForm()])),
      ),
    );
  }
}
