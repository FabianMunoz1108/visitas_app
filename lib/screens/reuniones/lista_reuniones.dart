import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/screens/reuniones/agregar_reunion.dart';
import 'package:visitas_app/services/reunion_service.dart';
import 'package:visitas_app/utils/alert.dart';
import 'package:visitas_app/utils/custom.dart';

class ListaReunion extends StatefulWidget {
  const ListaReunion({super.key});

  @override
  State<ListaReunion> createState() => _ListaReunionState();
}

class _ListaReunionState extends State<ListaReunion> {
  bool _isLoading = true;
  final _service = ReunionService();
  List<ReunionModel> _reuniones = [];
  List<ReunionModel> _filteredReuniones = [];
  Map<int, int> _indexMap =
      {}; // Mapea el índice original a los índices filtrados

  @override
  void initState() {
    super.initState();
    _cargarReuniones();
  }

  //Obtiene listado de reuniones
  void _cargarReuniones() async {
    try {
      final reuniones = await _service.getReuniones();

      setState(() {
        _reuniones = reuniones;
        _filteredReuniones =
            List.from(reuniones); // Inicializa la lista filtrada
        _isLoading = false;

        _indexMap = {
          for (var index in List.generate(_reuniones.length, (index) => index))
            index: index
        }; // Inicializa el mapeo de índices
      });
    } catch (e) {
      print('Error al cargar las reuniones: $e');
    }
  }

  //Elimina de la lista la reunión seleccionada
  Future<bool> _eliminarReunion(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.deleteReunion(_reuniones[index].reuId);

      setState(() {
        _reuniones.removeAt(index);
        _filteredReuniones
            .removeAt(_indexMap[index]!); // Elimina de la lista filtrada
        _indexMap.remove(index); // Elimina del mapeo de índices
      });
      return true;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al eliminar la reunión');

      print('Error al eliminar la reunión: $e  ');
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filtra la lista de reuniones basado en el texto de búsqueda
  void _filtrarReuniones(String query) {
    setState(() {
      _filteredReuniones = _reuniones
          .where((reunion) =>
              reunion.lugar.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Actualiza el mapeo de índices
      _indexMap = {
        for (var index
            in List.generate(_filteredReuniones.length, (index) => index))
          index: _reuniones.indexOf(_filteredReuniones[index])
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Reuniones'),
        trailing:
            //Inicio botón agregar reunión
            CustomNavigationButton(
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AgregarReunion(
                  onAgregarItem: (item) {
                    setState(() {
                      _reuniones.add(item);

                      // Agrega a la lista filtrada
                      _filteredReuniones.add(item);
                      // Actualiza el mapeo de índices
                      _indexMap[_reuniones.length - 1] =
                          _filteredReuniones.length - 1;
                    });

                    Navigator.of(context).pop();
                  },
                  itemToUpdate: null,
                ),
              ),
            );
          },
        ),
        //Fin botón agregar reunión
      ),
      child: SafeArea(
          child: _isLoading
              ? const Center(
                  child:
                      CupertinoActivityIndicator()) // Indicador de carga de datos
              : Column(
                  children: [
                    //Inicio widget de búsqueda
                    CustomSearchTextField(
                        onChanged: _filtrarReuniones,
                        placeholder: 'Buscar reunión'),
                    //Fin widget de búsqueda
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredReuniones.length,
                        itemBuilder: (context, index) {
                          final reunion = _filteredReuniones[index];

                          //parsear la fecha
                          final fecha = DateTime.parse(reunion.horario);

                          //formatear la fecha
                          final fechaFormateada =
                              '${fecha.day}/${fecha.month}/${fecha.year}';

                          return CupertinoListTile(
                              title: Text(reunion.lugar),
                              subtitle: Text(
                                  'Fecha: $fechaFormateada, Duración: ${reunion.duracion} hr(s)'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Inicio botón de eliminación de reunión
                                  CustomNavigationButton(
                                    child: const Icon(CupertinoIcons.delete),
                                    onPressed: () {
                                      //solictud de confirmación para eliminar reunión
                                      showActionSheet(context,
                                          title:
                                              "¿Desea eliminar esta reunión?",
                                          actions: ['Confirmar'],
                                          onSelected: (String action) {
                                        if (action == 'Confirmar') {
                                          _eliminarReunion(_indexMap[index]!);
                                        }
                                      });
                                    },
                                  ),
                                  //Fin botón de eliminación de reunión

                                  //Inicio botón de edición de reunión
                                  CustomNavigationButton(
                                    child: const Icon(
                                        CupertinoIcons.arrow_right_circle),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              AgregarReunion(
                                            onAgregarItem: (item) {
                                              setState(() {
                                                _reuniones[_indexMap[index]!] =
                                                    item;
                                                _filteredReuniones[index] =
                                                    item;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            //Envío de item a widget para edición
                                            itemToUpdate:
                                                _reuniones[_indexMap[index]!],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  //Fin botón de edición de reunión
                                ],
                              ));
                        },
                      ),
                    )
                  ],
                )),
    );
  }
}
