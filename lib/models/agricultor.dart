class Agricultor {
  String? id;
  String nombre;
  int? edad;
  String zona;
  String experiencia;

  Agricultor({
    this.id,
    required this.nombre,
    this.edad,
    required this.zona,
    required this.experiencia,
  });

  factory Agricultor.fromMap(Map<String, dynamic> map, [String? id]) {
    return Agricultor(
      id: id,
      nombre: map['nombre'] ?? '',
      edad: map['edad'] ?? 0,
      zona: map['zona'] ?? '',
      experiencia: map['experiencia'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
      'zona': zona,
      'experiencia': experiencia,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Agricultor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
