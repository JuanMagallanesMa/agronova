import 'package:agronova/models/agricultor.dart';
import 'package:agronova/providers/agricultor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistroAgricultorScreen extends StatefulWidget {
  final Agricultor? agricultor;

  const RegistroAgricultorScreen({super.key, this.agricultor});

  @override
  State<RegistroAgricultorScreen> createState() =>
      _RegistroAgricultorScreenState();
}

class _RegistroAgricultorScreenState extends State<RegistroAgricultorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _zonaController = TextEditingController();
  final _experienciaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.agricultor != null) {
      _nombreController.text = widget.agricultor!.nombre;
      _edadController.text = widget.agricultor!.edad?.toString() ?? '';
      _zonaController.text = widget.agricultor!.zona ?? '';
      _experienciaController.text =
          widget.agricultor!.experiencia?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _zonaController.dispose();
    _experienciaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final agricultoresProvider = Provider.of<AgricultorProvider>(
        context,
        listen: false,
      );

      if (widget.agricultor == null) {
        agricultoresProvider.addAgricultor(
          Agricultor(
            nombre: _nombreController.text,
            edad: int.tryParse(_edadController.text),
            zona: _zonaController.text,
            experiencia: _experienciaController.text,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Agricultor registrado')));
      } else {
        final actualizado = widget.agricultor!;
        actualizado.nombre = _nombreController.text;
        actualizado.edad = int.tryParse(_edadController.text);
        actualizado.zona = _zonaController.text;
        actualizado.experiencia = _experienciaController.text;

        agricultoresProvider.updateAgricultor(actualizado);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Agricultor actualizado')));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.agricultor == null
              ? 'Registrar Agricultor'
              : 'Editar Agricultor',
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
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese la edad';
                  final n = int.tryParse(value);
                  if (n == null || n <= 0) return 'Edad inválida';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _zonaController,
                decoration: InputDecoration(
                  labelText: 'Zona',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese la zona' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _experienciaController,
                decoration: InputDecoration(
                  labelText: 'Experiencia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese la experiencia'
                    : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.agricultor == null ? 'Registrar' : 'Actualizar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
