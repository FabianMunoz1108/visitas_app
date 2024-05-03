import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/screens/personas/agregar_persona.dart';
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
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Personas'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AgregarPersona(
                  onAgregarItem: (item) {
                    setState(() {
                      _personas.add(item);
                    });

                    Navigator.of(context).pop();
                  },
                  itemToUpdate: null,
                ),
              ),
            );
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child:
                    CupertinoActivityIndicator()) // Centered activity indicator
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
                          /************************************************/
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child:
                                const Icon(CupertinoIcons.arrow_right_circle),
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AgregarPersona(
                                    onAgregarItem: (item) {
                                      setState(() {
                                        _personas[index] = item;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    //Envío de item a widget para edición
                                    itemToUpdate: _personas[index],
                                  ),
                                ),
                              );
                            },
                          ),
                          /************************************************/
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
