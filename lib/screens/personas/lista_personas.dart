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
  List<PersonaModel> _filteredPersonas = [];
  Map<int, int> _indexMap =
      {}; // Mapea el índice original a los índices filtrados

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
        _filteredPersonas = List.from(personas); // Inicializa la lista filtrada
        _isLoading = false;
        _indexMap = {
          for (var index in List.generate(_personas.length, (index) => index))
            index: index
        }; // Initialize index mapping
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
        _filteredPersonas
            .removeAt(_indexMap[index]!); // Elimina de la lista filtrada
        _indexMap.remove(index); // Elimina del mapeo de índices
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

  // Filtra las lista de personas basado en el texto de búsqueda
  void _filterPersonas(String query) {
    setState(() {
      _filteredPersonas = _personas
          .where((persona) =>
              persona.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Actualiza el mapeo de índices
      _indexMap = {
        for (var index
            in List.generate(_filteredPersonas.length, (index) => index))
          index: _personas.indexOf(_filteredPersonas[index])
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Personas'),
        trailing:
            // Inicio botón agregar persona
            CustomNavigationButton(
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AgregarPersona(
                  onAgregarItem: (item) {
                    setState(() {
                      _personas.add(item);
                      // Agraga a la lista de personas
                      _filteredPersonas.add(item);
                      // Actualiza el mapa de índices
                      _indexMap[_personas.length - 1] =
                          _filteredPersonas.length - 1;
                    });

                    Navigator.of(context).pop();
                  },
                  itemToUpdate: null,
                ),
              ),
            );
          },
        ),
        // Fin botón agregar persona
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child:
                    CupertinoActivityIndicator()) //Indicador de carga de datos
            : Column(
                children: [
                  // Inicio widget de búsqueda
                  CustomSearchTextField(
                      onChanged: _filterPersonas,
                      placeholder: 'Buscar persona'),
                  // Fin widget de búsqueda
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredPersonas.length,
                      itemBuilder: (context, index) {
                        final persona = _filteredPersonas[index];

                        return CupertinoListTile(
                          title: Text(persona.nombre),
                          subtitle: Text('Área: ${persona.area}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Inicio botón eliminar persona
                              CustomNavigationButton(
                                child: const Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  showActionSheet(context,
                                      title: "¿Desea eliminar esta persona?",
                                      actions: ['Confirmar'],
                                      onSelected: (String action) {
                                    if (action == 'Confirmar') {
                                      _eliminarPersona(_indexMap[
                                          index]!);
                                    }
                                  });
                                },
                              ),
                              // Fin botón eliminar persona
                              
                              // Inicio botón editar persona
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
                                            _personas[_indexMap[index]!] =
                                                item;
                                            _filteredPersonas[index] = item;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        // Envío de item a widget para edición
                                        itemToUpdate: _personas[_indexMap[
                                            index]!],
                                      ),
                                    ),
                                  );
                                },
                              )
                              // Fin botón editar persona
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
