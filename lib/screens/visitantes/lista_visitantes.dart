import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/screens/visitantes/agregar_visitante.dart';
import 'package:visitas_app/services/visitante_service.dart';
import 'package:visitas_app/utils/alert.dart';
import 'package:visitas_app/utils/custom.dart';

class ListaVisitante extends StatefulWidget {
  const ListaVisitante({super.key});

  @override
  State<ListaVisitante> createState() => _ListaVisitanteState();
}

class _ListaVisitanteState extends State<ListaVisitante> {
  bool _isLoading = true;
  final _service = VisitanteService();
  List<VisitanteModel> _visitantes = [];
  List<VisitanteModel> _filteredVisitantes = [];
  Map<int, int> _indexMap =
      {}; // Mapea el índice original a los índices filtrados

  @override
  void initState() {
    super.initState();
    _cargarVisitantes();
  }

  //Obtiene lista de visitantes
  void _cargarVisitantes() async {
    try {
      final visitantes = await _service.getVisitantes();

      setState(() {
        _visitantes = visitantes;
        _filteredVisitantes =
            List.from(visitantes); // Inicializa la lista filtrada
        _isLoading = false;

        _indexMap = {
          for (var index in List.generate(_visitantes.length, (index) => index))
            index: index
        }; // Inicializa el mapeo de índices
      });
    } catch (e) {
      print('Error al cargar los visitantes: $e');
    }
  }

  //Elimina de la lista el visitante seleccionado
  Future<bool> _eliminarVisitante(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.deleteVisitante(_visitantes[index].visId);

      setState(() {
        _visitantes.removeAt(index);
        _filteredVisitantes
            .removeAt(_indexMap[index]!); // Elimina de la lista filtrada
        _indexMap.remove(index); // Elimina del mapeo de índices
      });
      return true;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al eliminar el visitante');

      print('Error al eliminar el visitante: $e  ');
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filtra la lista de visitantes basado en el texto de búsqueda
  void _filtrarVisitantes(String query) {
    setState(() {
      _filteredVisitantes = _visitantes
          .where((visitante) =>
              visitante.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Actualiza el mapeo de índices
      _indexMap = {
        for (var index
            in List.generate(_filteredVisitantes.length, (index) => index))
          index: _visitantes.indexOf(_filteredVisitantes[index])
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Listado de Visitantes'),
          trailing:
              //Inicio botón agregar visitante
              CustomNavigationButton(
            child: const Icon(CupertinoIcons.add),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (BuildContext context) => AgregarVisitante(
                    onAgregarItem: (item) {
                      setState(() {
                        _visitantes.add(item);
                        // Agrega a la lista filtrada
                        _filteredVisitantes.add(item);
                        // Actualiza el mapeo de índices
                        _indexMap[_visitantes.length - 1] = _filteredVisitantes.length - 1;
                      });

                      Navigator.of(context).pop();
                    },
                    itemToUpdate: null,
                  ),
                ),
              );
            },
          ),
          //Fin botón agregar visitante
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child:
                      CupertinoActivityIndicator()) // Centered activity indicator
              : Column(
                  children: [
                    // Inicio widget de búsqueda
                    CustomSearchTextField(
                      onChanged: _filtrarVisitantes,
                      placeholder: 'Buscar visitante',
                    ),
                    // Fin widget de búsqueda
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredVisitantes.length,
                        itemBuilder: (context, index) {
                          final visitante = _filteredVisitantes[index];

                          return CupertinoListTile(
                              title: Text(visitante.nombre),
                              subtitle: Text('Origen: ${visitante.origen}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Inicio botón de eliminación de visitante
                                  CustomNavigationButton(
                                    child: const Icon(CupertinoIcons.delete),
                                    onPressed: () {
                                      //solictud de confirmación para eliminar visitante
                                      showActionSheet(context,
                                          title:
                                              "¿Desea eliminar este visitante?",
                                          actions: ['Confirmar'],
                                          onSelected: (String action) {
                                        if (action == 'Confirmar') {
                                          _eliminarVisitante(_indexMap[index]!);
                                        }
                                      });
                                    },
                                  ),
                                  //Fin botón de eliminación de visitante

                                  //Inicio botón de edición de visitante
                                  CustomNavigationButton(
                                    child: const Icon(
                                        CupertinoIcons.arrow_right_circle),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              AgregarVisitante(
                                            onAgregarItem: (item) {
                                              setState(() {
                                                _visitantes[_indexMap[index]!] = item;
                                                _filteredVisitantes[index] = item;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            //Envío de item a widget para edición
                                            itemToUpdate: _visitantes[_indexMap[index]!],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  //Fin botón de edición de visitante
                                ],
                              ));
                        },
                      ),
                    ),
                  ],
                ),
        ));
  }
}
