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
        _isLoading = false;
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: _visitantes.length,
                        itemBuilder: (context, index) {
                          final visitante = _visitantes[index];

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
                                          _eliminarVisitante(index);
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
                                                _visitantes[index] = item;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            //Envío de item a widget para edición
                                            itemToUpdate: _visitantes[index],
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
