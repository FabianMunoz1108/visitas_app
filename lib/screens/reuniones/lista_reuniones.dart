import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/screens/reuniones/agregar_reunion.dart';
import 'package:visitas_app/services/visitas_service.dart';

class ListaReunion extends StatefulWidget {
  const ListaReunion({super.key});

  @override
  State<ListaReunion> createState() => _ListaReunionState();
}

class _ListaReunionState extends State<ListaReunion> {
  bool _isLoading = true;
  List<ReunionModel> _reuniones = [];

  @override
  void initState() {
    super.initState();
    _cargarReuniones();
  }

  void _cargarReuniones() async {
    var service = VisitasService();
    try {
      final reuniones = await service.getReuniones();

      setState(() {
        _reuniones = reuniones;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las reuniones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Reuniones'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
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
                            subtitle: Text('Fecha: $fechaFormateada'),
                            /************************************************/
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child:
                                  const Icon(CupertinoIcons.arrow_right_circle),
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
                            /************************************************/
                          );
                        },
                      ),
                    )
                  ],
                )),
    );
  }
}
