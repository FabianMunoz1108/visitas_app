class UsuarioModel {
  String userName;
  String password;

  UsuarioModel({required this.userName, required this.password});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      userName: json['userName'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
      };
}