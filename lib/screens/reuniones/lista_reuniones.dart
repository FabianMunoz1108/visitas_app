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
        _isLoading = false;
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
                      CupertinoActivityIndicator()) // Centered activity indicator
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _reuniones.length,
                        itemBuilder: (context, index) {
                          final reunion = _reuniones[index];

                          //parsear la fecha
                          final fecha = DateTime.parse(reunion.horario);

                          //formatear la fecha
                          final fechaFormateada =
                              '${fecha.day}/${fecha.month}/${fecha.year}';

                          return CupertinoListTile(
                              title: Text(reunion.lugar),
                              subtitle: Text('Fecha: $fechaFormateada, Duración: ${reunion.duracion} hr(s)'),
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
                                          _eliminarReunion(index);
                                        }
                                      });
                                    },
                                  ),
                                  //Fin botón de eliminación de reunión

                                  //Inicio botón de edición de reunión
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                        CupertinoIcons.arrow_right_circle),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              AgregarReunion(
                                            onAgregarItem: (item) {
                                              setState(() {
                                                _reuniones[index] = item;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            //Envío de item a widget para edición
                                            itemToUpdate: _reuniones[index],
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
