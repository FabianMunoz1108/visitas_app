import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/usuario_model.dart';
import 'package:visitas_app/screens/welcome.dart';
import 'package:visitas_app/services/visitas_service.dart';
import 'package:visitas_app/utils/alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _emailController.text = 'donjulio';
      _passwordController.text = 'hola1234\$';
    });
  }

  Future<bool> _validarUsuario() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;

    //Validación de credenciales en el servicio
    var service = VisitasService();
    var credenciales = UsuarioModel(userName: email, password: password);
    final flag = await service.login(credenciales);

    if (flag) {
      return true;
    } else {
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Acceso a visitas'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Image.asset('assets/200-NEGRO.png')),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading) const Center(child: CupertinoActivityIndicator()),
              if (!_isLoading) ...[

              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Usuario',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Contraseña',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                child: const Text('Entrar'),
                onPressed: () async {
                  // Valida captura de usuario y contraseña
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showAlertDialog(
                      context,
                      title: 'Info',
                      content: 'Ingrese usuario y contraseña',
                    );
                  } else {
                    final flag = await _validarUsuario();

                    if (flag) {
                      //Redirección a la pantalla de visitas
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => const Welcome()),
                      );
                    } else {
                      showAlertDialog(context,
                          title: 'Error',
                          content: 'Usuario y/o contraseña incorrectos');
                    }
                  }
                },
              ),

              ]
            ],
          ),
        ),
      ),
    );
  }
}
