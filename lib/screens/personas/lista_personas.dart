import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/screens/personas/agregar_persona.dart';
import 'package:visitas_app/services/persona_service.dart';
import 'package:visitas_app/utils/alert.dart';
import 'package:visitas_app/utils/custom.dart';

class ListaPersona extends StatefulWidget {
  const ListaPersona({super.key});

  @override
  State<ListaPersona> createState() => _ListaPersonaState();
}

class _ListaPersonaState extends State<ListaPersona> {
  bool _isLoading = true;
  final _service = PersonaService();
  List<PersonaModel> _personas = [];

  @override
  void initState() {
    super.initState();
    _cargarPersonas();
  }

  //Obtiene listado de personas
  void _cargarPersonas() async {
    try {
      final personas = await _service.getPersonas();

      setState(() {
        _personas = personas;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las personas: $e');
    }
  }

  //Elimina de la lista la persona seleccionada
  Future<bool> _eliminarPersona(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.deletePersona(_personas[index].perId);

      setState(() {
        _personas.removeAt(index);
      });
      return true;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al eliminar la persona');

      print('Error al eliminar la persona: $e  ');
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Personas'),
        trailing:
            //Inicio botón de agregar persona
            CustomNavigationButton(
          child: const Icon(CupertinoIcons.add),
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
        ),
        //Fin botón agregar persona
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child:
                    CupertinoActivityIndicator()) //Indicador de carga de datos
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _personas.length,
                      itemBuilder: (context, index) {
                        final persona = _personas[index];

                        return CupertinoListTile(
                          title: Text(persona.nombre),
                          subtitle: Text('Área: ${persona.area}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //Inicio botón de eliminación de persona
                              CustomNavigationButton(
                                child: const Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  //solictud de confirmación para eliminar persona
                                  showActionSheet(context,
                                      title: "¿Desea eliminar esta persona?",
                                      actions: ['Confirmar'],
                                      onSelected: (String action) {
                                    if (action == 'Confirmar') {
                                      _eliminarPersona(index);
                                    }
                                  });
                                },
                              ),
                              //Fin botón de eliminación de persona

                              //Inicio botón de edición de persona
                              CustomNavigationButton(
                                child: const Icon(
                                    CupertinoIcons.arrow_right_circle),
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
                              )
                              //Fin botón de edición de persona
                            ],
                          ),
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
