import 'package:agronova/models/cultivo.dart';


class Venta {
  final String? id;
  final String nombre;
  final String cedula;
  final List<Cultivo> productos;
  final double total;

  Venta({
    this.id,
    required this.nombre,
    required this.cedula,
    required this.productos,
    required this.total,
  }) : assert(total >= 0, 'El total no puede ser negativo');
}
