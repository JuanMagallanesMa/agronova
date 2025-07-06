import 'package:agronova/models/agricultor.dart';
import 'package:flutter/material.dart';

class AgricultorProvider extends ChangeNotifier {
  final List<Agricultor> _agricultores = [];
  List<Agricultor> get agricultores => _agricultores;

  void addAgricultor(Agricultor agricultor) {
    _agricultores.add(agricultor);
    notifyListeners();
  }

  List<Agricultor> searchAgricultores(String query) {
    if (query.isEmpty) {
      return _agricultores;
    }
    return _agricultores
        .where(
          (agricultor) =>
              agricultor.nombre.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void deleteAgricultor(String id) {
    _agricultores.removeWhere((agricultor) => agricultor.id == id);
    notifyListeners();
  }

  void updateAgricultor(Agricultor updatedAgricultor) {
    final index = _agricultores.indexWhere(
      (agricultor) => agricultor.id == updatedAgricultor.id,
    );
    if (index != -1) {
      _agricultores[index] = updatedAgricultor;
      notifyListeners();
    }
  }
}
