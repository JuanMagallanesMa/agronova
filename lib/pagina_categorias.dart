import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'pagina_cultivos.dart';
import 'pagina_agricultores.dart';
import 'pagina_inventario_agricola.dart';
import 'pagina_tarea_riego_fertilizacion.dart';
import 'pagina_mercado_ventas.dart';

class Categoria {
  final String nombre;
  final String descripcion;
  final String imagen;

  Categoria({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
    );
  }
}

class PaginaCategorias extends StatefulWidget {
  const PaginaCategorias({super.key});

  @override
  State<PaginaCategorias> createState() => _PaginaCategoriasState();
}

class _PaginaCategoriasState extends State<PaginaCategorias> {
  List<Categoria> categorias = [];

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    final String respuesta = await rootBundle.loadString('assets/datos.json');
    final List<dynamic> datos = json.decode(respuesta);
    setState(() {
      categorias = datos.map((item) => Categoria.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          return InkWell(
            onTap: () {
              Widget? destino;

              switch (categoria.nombre.toLowerCase()) {
                case 'cultivos':
                  destino = const PaginaCultivos();
                  break;
                case 'agricultores':
                  destino = const PaginaAgricultores();
                  break;
                case 'inventario agricola':
                  destino = const PaginaInventarioAgricola();
                  break;
                case 'tarea de riego y fertilizacion':
                  destino = const PaginaTareaRiegoFertilizacion();
                  break;
                case 'mercado y ventas':
                  destino = const PaginaMercadoVentas();
                  break;
                default:
                  destino = null;
              }

              if (destino != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destino!),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'No hay página disponible para "${categoria.nombre}"',
                    ),
                  ),
                );
              }
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(categoria.imagen),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoria.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categoria.descripcion,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
