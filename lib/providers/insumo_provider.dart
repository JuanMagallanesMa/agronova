import 'package:agronova/models/insumo.dart';
import 'package:flutter/material.dart';

class InsumoProvider extends ChangeNotifier {
  final List<InsumoAgricola> _insumos = [];

  List<InsumoAgricola> get insumos => _insumos;

  void addInsumo(InsumoAgricola insumo) {
    _insumos.add(insumo);
    notifyListeners();
  }

  void updateInsumo(InsumoAgricola insumo) {
    final index = _insumos.indexWhere((i) => i.id == insumo.id);
    if (index != -1) {
      _insumos[index] = insumo;
      notifyListeners();
    }
  }

  void deleteInsumo(String id) {
    _insumos.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  List<InsumoAgricola> searchInsumo(String descripcion, String tipo) {
    return _insumos.where((c) {
      final coincideDescripcion =
          descripcion.isEmpty ||
          c.descripcion.toLowerCase().contains(descripcion.toLowerCase());
      final coincideTipo =
          tipo.isEmpty || c.tipo.toLowerCase() == tipo.toLowerCase();
      return coincideDescripcion && coincideTipo;
    }).toList();
  }
}
