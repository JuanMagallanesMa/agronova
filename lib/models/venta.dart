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
  }) : cantidadesPorProducto = cantidadesPorProducto ?? {};

  factory Venta.fromMap(
    Map<String, dynamic> data, {
    required String id,
    required List<Cultivo> cultivosDisponibles,
  }) {
    final rawProductos = Map<String, dynamic>.from(
      data['cantidadesPorProducto'] ?? {},
    );
    final Map<Cultivo, int> cantidadesPorProducto = {};

    rawProductos.forEach((cultivoId, productoData) {
      final cultivo = cultivosDisponibles.firstWhere(
        (c) => c.id == cultivoId,
        orElse: () => Cultivo(
          id: cultivoId,
          nombre: productoData['nombre'] ?? 'Desconocido',
          categoria: 'Otros',
          fechaInicio: DateTime.now(),
          ubicacion: '',
          precioCaja: (productoData['precioCaja'] as num).toDouble(),
        ),
      );

      cantidadesPorProducto[cultivo] = (productoData['cantidad'] as num)
          .toInt();
    });

    return Venta(
      id: id,
      nombre: data['nombre'] ?? '',
      cedula: data['cedula'] ?? '',
      cantidadesPorProducto: cantidadesPorProducto,
      cantidad: data['cantidad'] ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    final cantidadesMap = cantidadesPorProducto.map((cultivo, cantidad) {
      return MapEntry(cultivo.id!, {
        'nombre': cultivo.nombre,
        'precioCaja': cultivo.precioCaja,
        'cantidad': cantidad,
      });
    });

    return {
      'nombre': nombre,
      'cedula': cedula,
      'cantidad': cantidad,
      'total': total,
      'cantidadesPorProducto': cantidadesMap,
    };
  }
}
