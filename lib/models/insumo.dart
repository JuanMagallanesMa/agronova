import 'package:cloud_firestore/cloud_firestore.dart';

class InsumoAgricola {
  String? id; // Cambiado a String para Firestore
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
  static List<String> unidadesMedida = [
    'kg',
    'litros',
    'unidades',
    
  ];
}
