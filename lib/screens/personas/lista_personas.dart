import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/services/visitas_service.dart';

class ListaPersona extends StatefulWidget {
  const ListaPersona({Key? key}) : super(key: key);

  @override
  State<ListaPersona> createState() => _ListaPersonaState();
}

class _ListaPersonaState extends State<ListaPersona> {
  bool _isLoading = true;
  List<PersonaModel> _personas = [];

  @override
  void initState() {
    super.initState();
    _cargarPersonas();
  }

  void _cargarPersonas() async {
    var service = VisitasService();

    try {
      final personas = await service.getPersonas();

      setState(() {
        _personas = personas;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las personas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Listado de Personas'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator()) // Centered activity indicator
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _personas.length,
                      itemBuilder: (context, index) {
                        final persona = _personas[index];

                        return CupertinoListTile(
                          title: Text(persona.nombre),
                          subtitle: Text('Área ${persona.area}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
