class Viaje {
  final String id;
  final DateTime fechaHora;
  final String ruta;
  final double precioFinal;

  Viaje({
    required this.id,
    required this.fechaHora,
    required this.ruta,
    required this.precioFinal,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'],
      fechaHora: DateTime.parse(json['fechaHora']),
      ruta: json['ruta'],
      precioFinal: json['precioFinal'],
    );
  }
}
