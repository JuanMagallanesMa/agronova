import 'package:agronova/models/agricultor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgricultorProvider extends ChangeNotifier {
  final List<Agricultor> _agricultores = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Agricultor> get agricultores => _agricultores;

  Future<void> fetchAgricultores() async {
    try {
      final snapshot = await _firestore.collection('agricultores').get();
      _agricultores.clear();
      for (var doc in snapshot.docs) {
        _agricultores.add(Agricultor.fromMap(doc.data(), doc.id));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar agricultores: $e');
    }
  }

  Future<void> addAgricultor(Agricultor agricultor) async {
    try {
      final docRef = await _firestore.collection('agricultores').add(agricultor.toMap());
      agricultor.id = docRef.id;
      _agricultores.add(agricultor);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al agregar agricultor: $e');
    }
  }

  Future<void> deleteAgricultor(String id) async {
    try {
      await _firestore.collection('agricultores').doc(id).delete();
      _agricultores.removeWhere((agricultor) => agricultor.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al eliminar agricultor: $e');
    }
  }

  Future<void> updateAgricultor(Agricultor agricultor) async {
    try {
      await _firestore.collection('agricultores').doc(agricultor.id).update(agricultor.toMap());
      final index = _agricultores.indexWhere((a) => a.id == agricultor.id);
      if (index != -1) {
        _agricultores[index] = agricultor;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al actualizar agricultor: $e');
    }
  }

  List<Agricultor> searchAgricultores(String query) {
    if (query.isEmpty) return _agricultores;
    return _agricultores
        .where((agricultor) =>
            agricultor.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
