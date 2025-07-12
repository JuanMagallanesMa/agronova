import 'package:agronova/models/cultivo.dart';
import 'package:agronova/models/venta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VentaProvider extends ChangeNotifier {
  final List<Venta> _ventas = [];
  final _firestore = FirebaseFirestore.instance;

  List<Venta> get ventas => _ventas;

  Future<void> cargarVentas(List<Cultivo> cultivosDisponibles) async {
  final snapshot = await _firestore.collection('ventas').get();
  _ventas.clear();

  for (var doc in snapshot.docs) {
    final venta = Venta.fromMap(
      doc.data(),
      id: doc.id,
      cultivosDisponibles: cultivosDisponibles,
    );
    _ventas.add(venta);
  }

  notifyListeners();
}


  Future<void> addVenta(Venta venta) async {
    final doc = await _firestore.collection('ventas').add(venta.toMap());
    venta.id = doc.id;
    _ventas.add(venta);
    notifyListeners();
  }

  Future<void> updateVenta(Venta venta) async {
    if (venta.id == null) return;
    await _firestore.collection('ventas').doc(venta.id).set(venta.toMap());
    final index = _ventas.indexWhere((v) => v.id == venta.id);
    if (index != -1) _ventas[index] = venta;
    notifyListeners();
  }

  Future<void> deleteVenta(String id) async {
    await _firestore.collection('ventas').doc(id).delete();
    _ventas.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  List<Venta> searchVentas(String query) {
    if (query.isEmpty) return _ventas;
    return _ventas.where((v) => v.cedula.contains(query)).toList();
  }
}
