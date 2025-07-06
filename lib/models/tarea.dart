import 'package:agronova/models/agricultor.dart';
import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/insumo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tarea {
  String? id;
  String nombre;
  String descripcion;
  Cultivo cultivo;
  DateTime fechaInicio;
  DateTime fechaFin;
  List<Agricultor> agricultores;
  List<InsumoAgricola> insumos;
  bool estado = false;

  Tarea({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.cultivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.agricultores,
    required this.insumos,
  });

  static List<String> estados = ['Pendiente', 'Completada'];
}
