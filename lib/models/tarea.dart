import 'package:agronova/models/agricultor.dart';
import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/insumo.dart';

class Tarea {
  String? id;
  String nombre;
  String descripcion;
  Cultivo cultivo;
  DateTime fechaInicio;
  DateTime fechaFin;
  List<Agricultor> agricultores;
  List<InsumoAgricola> insumos;
  bool estado;

  Tarea({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.cultivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.agricultores,
    required this.insumos,
    this.estado = false,
  });

  static List<String> estados = ['Pendiente', 'Completada'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'cultivo': cultivo.toMap(),
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'agricultores': agricultores.map((a) => a.toMap()).toList(),
      'insumos': insumos.map((i) => i.toMap()).toList(),
      'estado': estado,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      cultivo: Cultivo.fromMap(map['cultivo']),
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      agricultores: (map['agricultores'] as List)
          .map((a) => Agricultor.fromMap(a))
          .toList(),
      insumos: (map['insumos'] as List)
          .map((i) => InsumoAgricola.fromMap(i))
          .toList(),
      estado: map['estado'] ?? false,
    );
  }
}
