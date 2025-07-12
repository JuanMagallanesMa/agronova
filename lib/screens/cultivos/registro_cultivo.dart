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
      _categoriaSeleccionada = widget.cultivo!.categoria;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaInicioSeleccionada ?? DateTime.now(),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final cultivoProvider = Provider.of<CultivoProvider>(
        context,
        listen: false,
      );

      if (widget.cultivo == null) {
        // Crear nuevo Cultivo
        await cultivoProvider.addCultivo(
          Cultivo(
            id: Uuid().v4(),
            nombre: _nombreController.text,
            categoria: _categoriaSeleccionada ?? '',
            ubicacion: _ubicacionController.text,
            precioCaja: double.parse(_precioCajaController.text),
            fechaInicio: _fechaInicioSeleccionada!,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cultivo registrado')));
      } else {
        // Actualizar Cultivo existente
        final cultivoActualizado = Cultivo(
          id: widget.cultivo!.id,
          nombre: _nombreController.text,
          categoria: _categoriaSeleccionada ?? '',
          ubicacion: _ubicacionController.text,
          precioCaja: double.parse(_precioCajaController.text),
          fechaInicio: _fechaInicioSeleccionada!,
        );

        await cultivoProvider.updateCultivo(cultivoActualizado);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cultivo actualizado')));
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
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese la ubicación'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioCajaController,
                decoration: const InputDecoration(
                  labelText: 'Precio por Caja',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.attach_money),
                  suffixText: 'USD',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese el precio por caja'
                    : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Seleccione la fecha de inicio'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                ),
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
