import 'package:agronova/models/cultivo.dart';

class Venta {
  String? id;
  String nombre;
  String cedula;
  Map<Cultivo, int> cantidadesPorProducto;
  int cantidad;
  double total;

  Venta({
    this.id,
    required this.nombre,
    required this.cedula,
    Map<Cultivo, int>? cantidadesPorProducto,
    required this.total,
    required this.cantidad,
  }) : cantidadesPorProducto = cantidadesPorProducto ?? {},
       assert(total >= 0, 'El total no puede ser negativo');
}
