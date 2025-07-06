import 'dart:ffi';

import 'package:agronova/models/cultivo.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistroCultivoScreen extends StatefulWidget {
  final Cultivo? cultivo;

  const RegistroCultivoScreen({super.key, this.cultivo});

  @override
  State<RegistroCultivoScreen> createState() => _RegistroCultivoScreenState();
}

class _RegistroCultivoScreenState extends State<RegistroCultivoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _precioCajaController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  DateTime? _fechaInicioSeleccionada;
  String? _categoriaSeleccionada;

  late Cultivo cultivo;

  @override
  void initState() {
    super.initState();
    if (widget.cultivo != null) {
      _nombreController.text = widget.cultivo!.nombre;
      _categoriaController.text = widget.cultivo!.categoria;
      _ubicacionController.text = widget.cultivo!.ubicacion;
      _precioCajaController.text = widget.cultivo!.precioCaja.toString();
      _fechaInicioSeleccionada = widget.cultivo!.fechaInicio;
      _fechaInicioController.text =
          '${_fechaInicioSeleccionada!.day.toString().padLeft(2, '0')}/'
          '${_fechaInicioSeleccionada!.month.toString().padLeft(2, '0')}/'
          '${_fechaInicioSeleccionada!.year}';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaInicioSeleccionada = pickedDate;
        _fechaInicioController.text =
            '${_fechaInicioSeleccionada!.day.toString().padLeft(2, '0')}/'
            '${_fechaInicioSeleccionada!.month.toString().padLeft(2, '0')}/'
            '${_fechaInicioSeleccionada!.year}';
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _categoriaController.dispose();
    _ubicacionController.dispose();
    _precioCajaController.dispose();
    _fechaInicioController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cultivoProvider = Provider.of<CultivoProvider>(
        context,
        listen: false,
      );

      if (widget.cultivo == null) {
        // Crear nuevo Cultivo
        cultivoProvider.addCultivo(
          Cultivo(
            id: Uuid().v4(),
            nombre: _nombreController.text,
            categoria: _categoriaController.text,
            ubicacion: _ubicacionController.text,
            precioCaja: double.parse(_precioCajaController.text),
            fechaInicio: _fechaInicioSeleccionada!,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cultivo registrado')));
      } else {
        // Actualizar Cultivo existente
        widget.cultivo!.nombre = _nombreController.text;
        widget.cultivo!.categoria = _categoriaController.text;
        widget.cultivo!.ubicacion = _ubicacionController.text;
        widget.cultivo!.precioCaja = double.parse(_precioCajaController.text);
        widget.cultivo!.fechaInicio = _fechaInicioSeleccionada!;

        cultivoProvider.notifyListeners();

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
          widget.cultivo == null ? 'Registrar Cultivo' : 'Editar Cultivo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el nombre' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: Cultivo.categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _categoriaSeleccionada = valor;
                    _categoriaController.text = valor ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  labelText: 'Ubicacion',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese la ubicacion'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioCajaController,
                decoration: InputDecoration(
                  labelText: 'Precio por Caja',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.attach_money),
                  suffixText: 'USD',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese el precio por caja'
                    : null,
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Seleccione la fecha de inicio'
                    : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.cultivo == null ? 'Registrar' : 'Actualizar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
