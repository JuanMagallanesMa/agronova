import 'package:agronova/models/tarea.dart';
import 'package:agronova/models/venta.dart';
import 'package:flutter/material.dart';

class VentaProvider extends ChangeNotifier{
  final List<Venta> _venta = [];
  List<Venta> get ventas => _venta;

  void addVenta(Venta venta) {
    _venta.add(venta);
    notifyListeners();
  }

  void updateVenta(Venta venta) {
    final index = _venta.indexWhere((t) => t.id == venta.id);
    if (index != -1) {
      _venta[index] = venta;
      notifyListeners();
    }
  }

  void deleteVenta(String id) {
    _venta.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  List<Venta> searchVentas(String query) {
    if (query.isEmpty) {
      return _venta;
    }
    return _venta
        .where(
          (venta) =>
              venta.cedula.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

}