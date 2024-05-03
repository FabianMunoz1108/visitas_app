import 'package:flutter/cupertino.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Bienvenido al sistema de visitas'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
              Row(
                children: [
                  Expanded(child: Image.asset('assets/Congreso-GTO.png')),
                ],
              ),
          ]),
        ),
      ),
    );
  }
}
