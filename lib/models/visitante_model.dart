class VisitanteModel{
  int visId;
  String nombre;
  String origen;

  VisitanteModel({required this.visId, required this.nombre, required this.origen});

  factory VisitanteModel.fromJson(Map<String, dynamic> json) {
    return VisitanteModel(
      visId: json['visId'],
      nombre: json['nombre'],
      origen: json['origen'],
    );
  }

  Map<String, dynamic> toJson() => {
        'visId': visId,
        'nombre': nombre,
        'origen': origen,
      };
}