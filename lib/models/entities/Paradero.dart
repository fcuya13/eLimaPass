class Paradero {
  final String id;
  final String nombre;
  final String latitud;
  final String longitud;
  final bool sentidoIda;

  Paradero(
      {required this.id,
      required this.nombre,
      required this.latitud,
      required this.longitud,
      required this.sentidoIda});

  factory Paradero.fromJson(Map<String, dynamic> json) {
    return Paradero(
        id: json['id'].toString(),
        nombre: json['nombre'],
        latitud: json['latitud'].toString(),
        longitud: json['longitud'].toString(),
        sentidoIda: json['sentidoIda']);
  }
}
