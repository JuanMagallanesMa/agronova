import 'package:cloud_firestore/cloud_firestore.dart';

class InsumoAgricola {
  String? id;
  String tipo;
  String descripcion;
  int cantidad;
  String unidadMedida;

  InsumoAgricola({
    this.id,
    required this.tipo,
    required this.descripcion,
    required this.cantidad,
    required this.unidadMedida,
  }) : assert(cantidad >= 0, 'La cantidad no puede ser negativa');

  static List<String> tipos = [
    'Fertilizantes',
    'Pesticidas',
    'Semillas',
    'Agua de riego',
    'Maquinaria agrícola',
  ];

  static List<String> unidadesMedida = ['kg', 'litros', 'unidades'];

  factory InsumoAgricola.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InsumoAgricola(
      id: doc.id,
      tipo: data['tipo'],
      descripcion: data['descripcion'],
      cantidad: data['cantidad'],
      unidadMedida: data['unidadMedida'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'unidadMedida': unidadMedida,
    };
  }

  // InsumoAgricola

  factory InsumoAgricola.fromMap(Map<String, dynamic> map) => InsumoAgricola(
    id: map['id'],
    tipo: map['tipo'],
    descripcion: map['descripcion'],
    cantidad: map['cantidad'],
    unidadMedida: map['unidadMedida'],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsumoAgricola &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
