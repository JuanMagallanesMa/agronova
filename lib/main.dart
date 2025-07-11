import 'package:agronova/providers/agricultor_provider.dart';
import 'package:agronova/providers/cultivo_provider.dart';
import 'package:agronova/providers/insumo_provider.dart';
import 'package:agronova/providers/tarea_provider.dart';
import 'package:agronova/providers/venta_provider.dart';
import 'package:agronova/ventana_registro.dart';
import 'package:flutter/material.dart';

import 'package:agronova/pagina_inicio.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AgricultorProvider()),
      ChangeNotifierProvider(create: (_) => CultivoProvider()),
      ChangeNotifierProvider(create: (_) => InsumoProvider()),
      ChangeNotifierProvider(create: (_) => TareaProvider()),
      ChangeNotifierProvider(
        create: (_) => VentaProvider(),
      ), // Uncomment if you have a VentaProvider
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controladorClave = TextEditingController();
  final TextEditingController controladorCorreo = TextEditingController();
  final String _correo = 'admin@gmail.com';
  final String _clave = 'admin';
  String? _errorTextClave;
  String? _errorTextCorreo;

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

  void _irVentanaRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAppVentanaRegistro()),
    );
  }

  void _compararCorreoClave() {
    _validate();
    String correoIngresado = controladorCorreo.text;
    String claveIngresada = controladorClave.text;

    if ((correoIngresado == _correo) && (claveIngresada == _clave)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaginaInicio()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'AgroNova – Sistema Inteligente de Gestión Agrícola',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: controladorCorreo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo',
                    errorText: _errorTextCorreo,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: controladorClave,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    errorText: _errorTextClave,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: FilledButton(
                  onPressed: _compararCorreoClave,
                  child: const Text('Ingresar'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: FilledButton(
                  onPressed: _irVentanaRegistro,
                  child: const Text('Registrarse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
