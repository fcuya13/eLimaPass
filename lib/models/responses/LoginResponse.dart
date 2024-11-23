class LoginResponse {
  String id;
  String tarjeta;
  int tipo;

  LoginResponse({
    required this.id,
    required this.tarjeta,
    required this.tipo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        tarjeta: json["tarjeta"],
        tipo: json["tipo"],
      );
}
