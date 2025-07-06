class Agricultor {
  String? id; // Firestore usa String para IDs
  String nombre;
  int? edad;
  String? zona;
  String? experiencia;

  Agricultor({
    this.id,
    required this.nombre,
    this.edad,
    this.zona,
    this.experiencia,
  }) : assert(edad == null || edad >= 0, 'La edad no puede ser negativa');
}
