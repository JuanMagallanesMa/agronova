import 'package:agronova/models/tarea.dart';
import 'package:flutter/material.dart';

class TareaProvider extends ChangeNotifier{
  final List<Tarea> _tareas = [];
  List<Tarea> get tareas => _tareas;

  void addTarea(Tarea tarea) {
    _tareas.add(tarea);
    notifyListeners();
  }

  void updateTarea(Tarea tarea) {
    final index = _tareas.indexWhere((t) => t.id == tarea.id);
    if (index != -1) {
      _tareas[index] = tarea;
      notifyListeners();
    }
  }

  void deleteTarea(String id) {
    _tareas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  List<Tarea> searchTarea(String nombre, String estadoSeleccionado) {
  return _tareas.where((t) {
    final coincideNombre = nombre.isEmpty || t.nombre.toLowerCase().contains(nombre.toLowerCase());

    bool coincideEstado = true; 
    if (estadoSeleccionado.isNotEmpty) {
      if (estadoSeleccionado == Tarea.estados[0]) { 
        coincideEstado = t.estado == false;
      } else if (estadoSeleccionado == Tarea.estados[1]) {
        coincideEstado = t.estado == true;
      }
    }

    return coincideNombre && coincideEstado;
  }).toList();
}

}