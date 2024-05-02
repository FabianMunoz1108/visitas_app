class Credenciales {
  String userName;
  String password;

  Credenciales({required this.userName, required this.password});

  factory Credenciales.fromJson(Map<String, dynamic> json) {
    return Credenciales(
      userName: json['userName'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
      };
}