class PersonaModel {
  int perId;
  String nombre;
  String area;

  PersonaModel({required this.perId, required this.nombre, required this.area});

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      perId: json['perId'],
      nombre: json['nombre'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() => {
        'perId': perId,
        'nombre': nombre,
        'area': area,
      };
}