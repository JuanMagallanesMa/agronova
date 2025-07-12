import 'package:agronova/models/cultivo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CultivoProvider extends ChangeNotifier {
  final List<Cultivo> _cultivos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Cultivo> get cultivos => _cultivos;

  // Cargar cultivos desde Firestore
  Future<void> fetchCultivos() async {
    try {
      final querySnapshot = await _firestore.collection('cultivos').get();
      _cultivos.clear();
      for (var doc in querySnapshot.docs) {
        _cultivos.add(Cultivo.fromMap(doc.data(), doc.id));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar cultivos: $e');
    }
  }

  // Agregar cultivo a Firestore y a la lista
  Future<void> addCultivo(Cultivo cultivo) async {
    try {
      final docRef = await _firestore
          .collection('cultivos')
          .add(cultivo.toMap());
      cultivo.id = docRef.id;
      _cultivos.add(cultivo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al agregar cultivo: $e');
    }
  }

  // Eliminar cultivo de Firestore y de la lista
  Future<void> deleteCultivo(String id) async {
    try {
      await _firestore.collection('cultivos').doc(id).delete();
      _cultivos.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al eliminar cultivo: $e');
    }
  }

  // Actualizar cultivo en Firestore y en la lista
  Future<void> updateCultivo(Cultivo cultivo) async {
    try {
      await _firestore
          .collection('cultivos')
          .doc(cultivo.id)
          .update(cultivo.toMap());
      final index = _cultivos.indexWhere((c) => c.id == cultivo.id);
      if (index != -1) {
        _cultivos[index] = cultivo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al actualizar cultivo: $e');
    }
  }

  // Búsqueda local (no consulta en Firestore)
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
}
