import 'package:agronova/models/insumo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsumoProvider extends ChangeNotifier {
  final List<InsumoAgricola> _insumos = [];
  final _db = FirebaseFirestore.instance;
  final _collection = 'insumos';

  List<InsumoAgricola> get insumos => _insumos;

  Future<void> fetchInsumos() async {
    final snapshot = await _db.collection(_collection).get();
    _insumos.clear();
    for (var doc in snapshot.docs) {
      _insumos.add(InsumoAgricola.fromFirestore(doc));
    }
    notifyListeners();
  }

  Future<void> addInsumo(InsumoAgricola insumo) async {
    final docRef = await _db.collection(_collection).add(insumo.toMap());
    insumo.id = docRef.id;
    _insumos.add(insumo);
    notifyListeners();
  }

  Future<void> updateInsumo(InsumoAgricola insumo) async {
    if (insumo.id == null) return;
    await _db.collection(_collection).doc(insumo.id).update(insumo.toMap());
    final index = _insumos.indexWhere((i) => i.id == insumo.id);
    if (index != -1) {
      _insumos[index] = insumo;
      notifyListeners();
    }
  }

  Future<void> deleteInsumo(String id) async {
    await _db.collection(_collection).doc(id).delete();
    _insumos.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  List<InsumoAgricola> searchInsumo(String descripcion, String tipo) {
    return _insumos.where((c) {
      final coincideDescripcion = descripcion.isEmpty ||
          c.descripcion.toLowerCase().contains(descripcion.toLowerCase());
      final coincideTipo =
          tipo.isEmpty || c.tipo.toLowerCase() == tipo.toLowerCase();
      return coincideDescripcion && coincideTipo;
    }).toList();
  }
}
