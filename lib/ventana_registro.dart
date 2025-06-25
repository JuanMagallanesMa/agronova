import 'package:flutter/material.dart';
import 'dart:collection';

class MyAppVentanaRegistro extends StatelessWidget {
  const MyAppVentanaRegistro({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePageVentanaRegistro(title: 'Flutter Demo Home Page'),
    );
  }
}

enum Generos {
  femenino('Femenino'),
  masculino('Masculino'),
  otro('Otro');

  const Generos(this.label);
  final String label;
}

typedef NacionalidadEntry = DropdownMenuEntry<Nacionalidad>;

enum Nacionalidad {
  ecuatoriana('Ecuatoriana'),
  peruana('Peruana'),
  colombiana('Colombiana'),
  venezolana('Venezolana'),
  chilena('Chilena');

  const Nacionalidad(this.label);
  final String label;

  static final List<NacionalidadEntry> entries =
      UnmodifiableListView<NacionalidadEntry>(
        values.map<NacionalidadEntry>(
          (nacionalidad) =>
              NacionalidadEntry(value: nacionalidad, label: nacionalidad.label),
        ),
      );
}

class MyHomePageVentanaRegistro extends StatefulWidget {
  const MyHomePageVentanaRegistro({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaRegistro> createState() =>
      _MyHomePageStateVentanaRegistro();
}

class _MyHomePageStateVentanaRegistro extends State<MyHomePageVentanaRegistro> {
  TextEditingController controladorClave = TextEditingController();
  TextEditingController controladorCorreo = TextEditingController();
  TextEditingController controladorFechaNacimiento = TextEditingController();
  TextEditingController controladorNacionalidad = TextEditingController();
  TextEditingController controladorNombresApellidos = TextEditingController();
  TextEditingController controladorCedula = TextEditingController();

  final String _correo = 'admin@gmail.com';
  final String _clave = 'admin';
  String? _errorTextClave;
  String? _errorTextCorreo;
  bool _isChecked = true;
  Nacionalidad? _seleccionada;

  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        controladorFechaNacimiento.text =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      });
    }
  }

  Generos? _itemGenero = Generos.masculino;
  void _guardar() {
    print('=== DATOS DEL FORMULARIO ===');
    print('Nombres: ${controladorNombresApellidos.text}');
    print('Cédula: ${controladorCedula.text}');
    print('Correo: ${controladorCorreo.text}');
    print('Fecha Nacimiento: ${controladorFechaNacimiento.text}');
    print('Género: ${_itemGenero?.label}');
    print('Nacionalidad: ${_seleccionada?.label}');
  }

  void _limpiarFormulario() {
    setState(() {
      
      controladorNombresApellidos.clear();
      controladorCedula.clear();
      controladorCorreo.clear();
      controladorClave.clear();
      controladorFechaNacimiento.clear();
      controladorNacionalidad.clear();
      selectedDate = null;
      _itemGenero = Generos.masculino;
      _seleccionada = null;
    });
  }

  void _validate() {
    setState(() {
      if (controladorCorreo.text.trim().isEmpty) {
        _errorTextCorreo = 'Este campo es obligatorio';
      } else {
        _errorTextCorreo = null;
      }

      if (controladorClave.text.trim().isEmpty) {
        _errorTextClave = 'Este campo es obligatorio';
      } else {
        _errorTextClave = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/fondoTarea.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.6),
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 250, // aquí fijas el ancho total
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ingresarOpciones(),
                    const SizedBox(height: 20),
                    botones(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ingresarOpciones() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: controladorNombresApellidos,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Apellidos y Nombres',
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: controladorCedula,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Cedula',
          ),
        ),

        SizedBox(height: 20),
        DropdownMenu<Nacionalidad>(
          width: double.infinity,
          controller: controladorNacionalidad,
          label: const Text('Nacionalidad'),
          dropdownMenuEntries: Nacionalidad.entries,
          onSelected: (nacionalidad) {
            setState(() {
              _seleccionada = nacionalidad;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: controladorFechaNacimiento,
          onTap: _selectDate,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Fecha de nacimiento',
            errorText: _errorTextCorreo,
          ),
        ),
        SizedBox(height: 20),
        const Text('Género', style: TextStyle(fontWeight: FontWeight.bold)),
        ...Generos.values.map((genero) {
          return RadioListTile<Generos>(
            value: genero,
            groupValue: _itemGenero,
            onChanged: (Generos? value) {
              setState(() {
                _itemGenero = value;
              });
            },
            title: Text(genero.label),
          );
        }).toList(),
        SizedBox(height: 20),
        TextField(
          controller: controladorCorreo,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Correo',
            errorText: _errorTextCorreo,
          ),
        ),
        SizedBox(height: 20),

        TextField(
          controller: controladorClave,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Contraseña',
            errorText: _errorTextClave,
          ),
        ),
      ],
    );
  }

  Widget botones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FilledButton(
            onPressed: _guardar,
            child: const Text('Guardar'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: _limpiarFormulario,
            child: const Text('Borrar'),
          ),
        ),
      ],
    );
  }
}
