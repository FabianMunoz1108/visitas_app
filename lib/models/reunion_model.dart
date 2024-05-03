class ReunionModel {
  int reuId;
  String lugar;
  String horario;
  int duracion;
  int visId;
  int perId;

  ReunionModel(
      {required this.reuId,
      required this.lugar,
      required this.horario,
      required this.duracion,
      required this.visId,
      required this.perId});

  factory ReunionModel.fromJson(Map<String, dynamic> json) {
    return ReunionModel(
      reuId: json['reuId'],
      lugar: json['lugar'],
      horario: json['horario'],
      duracion: json['duracion'],
      visId: json['visId'],
      perId: json['perId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reuId': reuId,
        'lugar': lugar,
        'horario': horario,
        'duracion': duracion,
        'visId': visId,
        'perId': perId,
      };
}
