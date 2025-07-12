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

  // Convertir desde Firestore
  factory Cultivo.fromMap(Map<String, dynamic> data, [String? documentId]) {
    return Cultivo(
      id: documentId, // aquí debe llegar el id del documento Firestore
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? 'Otros',
      fechaInicio: (data['fechaInicio'] as Timestamp).toDate(),
      ubicacion: data['ubicacion'] ?? '',
      precioCaja: (data['precioCaja'] as num).toDouble(),
    );
  }

  // Convertir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'fechaInicio': fechaInicio,
      'ubicacion': ubicacion,
      'precioCaja': precioCaja,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cultivo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
