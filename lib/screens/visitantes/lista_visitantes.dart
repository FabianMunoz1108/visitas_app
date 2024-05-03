import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/screens/visitantes/agregar_visitante.dart';
import 'package:visitas_app/services/visitas_service.dart';

class ListaVisitante extends StatefulWidget {
  const ListaVisitante({super.key});

  @override
  State<ListaVisitante> createState() => _ListaVisitanteState();
}

class _ListaVisitanteState extends State<ListaVisitante> {
  bool _isLoading = true;
  List<VisitanteModel> _visitantes = [];

  @override
  void initState() {
    super.initState();
    _cargarVisitantes();
  }

  void _cargarVisitantes() async {
    var service = VisitasService();

    try {
      final visitantes = await service.getVisitantes();

      setState(() {
        _visitantes = visitantes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los visitantes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado de Visitantes'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
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
          child: const Icon(CupertinoIcons.add),
        ),
      ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child:
                      CupertinoActivityIndicator()) // Centered activity indicator
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      const CupertinoActivityIndicator()
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: _visitantes.length,
                          itemBuilder: (context, index) {
                            final visitante = _visitantes[index];

                            return CupertinoListTile(
                              title: Text(visitante.nombre),
                              subtitle: Text('Origen ${visitante.origen}'),

                          /************************************************/
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child:
                                const Icon(CupertinoIcons.arrow_right_circle),
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
                          /************************************************/


                            );
                          },
                        ),
                      ),
                  ],
                ),
        ));
  }
}
