import 'package:agronova/models/tarea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TareaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Tarea> _tareas = [];

  List<Tarea> get tareas => _tareas;

  Future<void> fetchTareas() async {
    final snapshot = await _firestore.collection('tareas').get();
    _tareas.clear();
    for (var doc in snapshot.docs) {
      final tarea = Tarea.fromMap(doc.data());
      _tareas.add(tarea);
    }
    notifyListeners();
  }

  Future<void> addTarea(Tarea tarea) async {
    final docRef = _firestore.collection('tareas').doc(tarea.id);
    await docRef.set(tarea.toMap());
    _tareas.add(tarea);
    notifyListeners();
  }

  Future<void> updateTarea(Tarea tarea) async {
    await _firestore.collection('tareas').doc(tarea.id).update(tarea.toMap());
    final index = _tareas.indexWhere((t) => t.id == tarea.id);
    if (index != -1) {
      _tareas[index] = tarea;
      notifyListeners();
    }
  }

  Future<void> deleteTarea(String id) async {
    await _firestore.collection('tareas').doc(id).delete();
    _tareas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  List<Tarea> searchTarea(String nombre, String estadoSeleccionado) {
    return _tareas.where((t) {
      final coincideNombre =
          nombre.isEmpty ||
          t.nombre.toLowerCase().contains(nombre.toLowerCase());

      bool coincideEstado = true;
      if (estadoSeleccionado.isNotEmpty) {
        coincideEstado = estadoSeleccionado == Tarea.estados[0]
            ? !t.estado
            : t.estado;
      }

      return coincideNombre && coincideEstado;
    }).toList();
  }
}
