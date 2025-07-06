import 'package:cloud_firestore/cloud_firestore.dart';

class Cultivo {
  String? id;
  String nombre;
  String categoria;
  DateTime fechaInicio;
  String ubicacion;
  double precioCaja;

  Cultivo({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.fechaInicio,
    required this.ubicacion,
    required this.precioCaja,
  }) : assert(precioCaja >= 0, 'El precio no puede ser negativo');

  static List<String> categorias = [
    'Frutas',
    'Verduras',
    'Granos',
    'Flores',
    'Otros',
  ];
}
