import 'package:flutter/cupertino.dart';
import 'package:visitas_app/screens/home.dart';
import 'package:visitas_app/screens/personas/lista_personas.dart';
import 'package:visitas_app/screens/reuniones/lista_reuniones.dart';
import 'package:visitas_app/screens/visitantes/lista_visitantes.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _HomeState();
}

class _HomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group_solid),
            label: 'Reuniones',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2), label: 'Personas'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Visitantes',
          ),
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const Home();
            case 1:
              return const ListaReunion();
            case 2:
              return const ListaPersona();
            default:
              return const ListaVisitante();
          }
        });
  }
}
