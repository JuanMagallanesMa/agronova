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
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  final _agricultoresController = TextEditingController();
  final _insumosController = TextEditingController();

  Cultivo? _cultivoSeleccionado;
  DateTime? _fechaInicioSeleccionada;
  DateTime? _fechaFinSeleccionada;
  List<Agricultor> _agricultoresSeleccionados = [];
  List<InsumoAgricola> _insumosSeleccionados = [];

  bool _didSetInitialCultivo = false;

  @override
  void initState() {
    super.initState();

    if (widget.tarea != null) {
      _nombreController.text = widget.tarea!.nombre;
      _descripcionController.text = widget.tarea!.descripcion;
      _fechaInicioSeleccionada = widget.tarea!.fechaInicio;
      _fechaFinSeleccionada = widget.tarea!.fechaFin;

      _fechaInicioController.text = _fechaInicioSeleccionada!
          .toIso8601String()
          .split('T')
          .first;
      _fechaFinController.text = _fechaFinSeleccionada!
          .toIso8601String()
          .split('T')
          .first;

      _agricultoresSeleccionados = List.from(widget.tarea!.agricultores);
      _insumosSeleccionados = List.from(widget.tarea!.insumos);

      _agricultoresController.text = _agricultoresSeleccionados
          .map((a) => a.nombre)
          .join(', ');
      _insumosController.text = _insumosSeleccionados
          .map((i) => i.descripcion)
          .join(', ');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didSetInitialCultivo && widget.tarea != null) {
      final cultivoProvider = Provider.of<CultivoProvider>(
        context,
        listen: false,
      );

      Cultivo? cultivoEncontrado;
      try {
        cultivoEncontrado = cultivoProvider.cultivos.firstWhere(
          (c) => c.id == widget.tarea!.cultivo.id,
        );
      } catch (e) {
        cultivoEncontrado = null;
      }

      setState(() {
        _cultivoSeleccionado = cultivoEncontrado;
        _didSetInitialCultivo = true;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un cultivo')),
        );
        return;
      }
      if (_fechaInicioSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fecha de inicio'),
          ),
        );
        return;
      }
      if (_fechaFinSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fecha de fin'),
          ),
        );
        return;
      }
      if (_agricultoresSeleccionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona al menos un agricultor'),
          ),
        );
        return;
      }
      if (_insumosSeleccionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona al menos un insumo'),
          ),
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
        tareaProvider.addTarea(nuevaTarea);
      } else {
        tareaProvider.updateTarea(nuevaTarea);
      }

      Navigator.pop(context);
    }
  }

  Widget _buildForm() {
    final cultivoProvider = Provider.of<CultivoProvider>(context);
    final agricultorProvider = Provider.of<AgricultorProvider>(context);
    final insumoProvider = Provider.of<InsumoProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la tarea',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Por favor ingresa un nombre'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Por favor ingresa una descripción'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Cultivo>(
            value: _cultivoSeleccionado, // puede ser null ahora
            hint: const Text('Selecciona un cultivo'),
            decoration: const InputDecoration(
              labelText: 'Cultivo',
              border: OutlineInputBorder(),
            ),
            items: cultivoProvider.cultivos.map((cultivo) {
              return DropdownMenuItem<Cultivo>(
                value: cultivo,
                child: Text(
                  '${cultivo.nombre} - ${cultivo.fechaInicio.toIso8601String().split('T').first}',
                ),
              );
            }).toList(),
            onChanged: (Cultivo? nuevoCultivo) {
              setState(() {
                _cultivoSeleccionado = nuevoCultivo;
              });
            },
            validator: (value) =>
                value == null ? 'Por favor selecciona un cultivo' : null,
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fechaInicioController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final fecha = await showDatePicker(
                      context: context,
                      initialDate: _fechaInicioSeleccionada ?? DateTime.now(),
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
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Por favor selecciona una fecha de inicio'
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _fechaFinController,
                  decoration: const InputDecoration(
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
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Por favor selecciona una fecha de fin'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _agricultoresController,
            decoration: const InputDecoration(
              labelText: 'Agricultores',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              List<Agricultor> tempSeleccionados = List.from(
                _agricultoresSeleccionados,
              );

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
                              final seleccionado = tempSeleccionados.any(
                                (a) => a.id == agric.id,
                              );
                              return CheckboxListTile(
                                title: Text(agric.nombre),
                                value: seleccionado,
                                onChanged: (bool? selected) {
                                  setStateDialog(() {
                                    if (selected == true) {
                                      if (!tempSeleccionados.any(
                                        (a) => a.id == agric.id,
                                      )) {
                                        tempSeleccionados.add(agric);
                                      }
                                    } else {
                                      tempSeleccionados.removeWhere(
                                        (a) => a.id == agric.id,
                                      );
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
          const SizedBox(height: 16),
          TextField(
            controller: _insumosController,
            decoration: const InputDecoration(
              labelText: 'Insumos',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              List<InsumoAgricola> tempSeleccionados = List.from(
                _insumosSeleccionados,
              );

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
                            children: insumoProvider.insumos.map((insumo) {
                              final seleccionado = tempSeleccionados.any(
                                (i) => i.id == insumo.id,
                              );
                              return CheckboxListTile(
                                title: Text(
                                  '${insumo.tipo} - ${insumo.descripcion} (${insumo.cantidad} ${insumo.unidadMedida})',
                                ),
                                value: seleccionado,
                                onChanged: (bool? selected) {
                                  setStateDialog(() {
                                    if (selected == true) {
                                      if (!tempSeleccionados.any(
                                        (i) => i.id == insumo.id,
                                      )) {
                                        tempSeleccionados.add(insumo);
                                      }
                                    } else {
                                      tempSeleccionados.removeWhere(
                                        (i) => i.id == insumo.id,
                                      );
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
                        (i) =>
                            '${i.descripcion} (${i.cantidad} ${i.unidadMedida})',
                      )
                      .join(', ');
                });
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(
              widget.tarea == null ? 'Registrar Tarea' : 'Actualizar Tarea',
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
        title: Text(widget.tarea == null ? 'Registrar Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: _buildForm()),
      ),
    );
  }
}
