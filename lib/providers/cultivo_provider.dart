import 'package:agronova/models/cultivo.dart';
import 'package:flutter/material.dart';

class CultivoProvider extends ChangeNotifier {
  final List<Cultivo> _cultivos = [];
  List<Cultivo> get cultivos => _cultivos;

  void addCultivo(Cultivo cultivos) {
    _cultivos.add(cultivos);
    notifyListeners();
  }

  List<Cultivo> searchCultivo(String nombre, String categoria) {
    return _cultivos.where((c) {
      final coincideNombre =
          nombre.isEmpty ||
          c.nombre.toLowerCase().contains(nombre.toLowerCase());
      final coincideCategoria =
          categoria.isEmpty ||
          c.categoria.toLowerCase() == categoria.toLowerCase();
      return coincideNombre && coincideCategoria;
    }).toList();
  }

  

  void deleteCultivo(String id) {
    _cultivos.removeWhere((cultivos) => cultivos.id == id);
    notifyListeners();
  }

  void updateCultivo(Cultivo updatedCultivo) {
    final index = _cultivos.indexWhere(
      (cultivo) => cultivo.id == updatedCultivo.id,
    );
    if (index != -1) {
      _cultivos[index] = updatedCultivo;
      notifyListeners();
    }
  }
}
