import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/services/visitas_service.dart';

class ListaVisitante extends StatefulWidget {
  const ListaVisitante({Key? key}) : super(key: key);

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
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Listado de Visitantes'),
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
                            );
                          },
                        ),
                      ),
                  ],
                ),
        ));
  }
}
