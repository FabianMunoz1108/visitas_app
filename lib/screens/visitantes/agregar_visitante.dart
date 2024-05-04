import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/services/visitante_service.dart';
import 'package:visitas_app/utils/alert.dart';

class AgregarVisitante extends StatefulWidget {
  //Item especifico para edición
  final VisitanteModel? itemToUpdate;
  final Function(VisitanteModel) onAgregarItem;

  const AgregarVisitante(
      {super.key, required this.onAgregarItem, required this.itemToUpdate});

  @override
  State<AgregarVisitante> createState() => _AgregarVisitanteState();
}

class _AgregarVisitanteState extends State<AgregarVisitante> {
  int _visitanteId = 0;
  bool _isLoading = false;
  final _service = VisitanteService();
  final _nombreController = TextEditingController(text: "");
  final _origenController = TextEditingController(text: "");

  @override
  void initState() {
    //La llamada a super debe ser la primera en el método
    super.initState();

    if (widget.itemToUpdate != null) {
      _visitanteId = widget.itemToUpdate!.visId;
      _nombreController.text = widget.itemToUpdate!.nombre;
      _origenController.text = widget.itemToUpdate!.origen;
    }
  }

  //Guarda o actualiza un visitante
  Future<int> _saveVisitante(VisitanteModel model) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var id = 0;
      if (model.visId > 0) {
        id = await _service.putVisitante(model);
      } else {
        id = await _service.postVisitante(model);
      }
      return id;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al guardar el visitante');

      print('Error al guardar el visitante: $e  ');
      return 0;
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
        middle: Text(widget.itemToUpdate == null
            ? 'Agregar Visitante'
            : 'Actualizar Visitante'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            // Item to add or update
            var v = VisitanteModel(
              visId: _visitanteId,
              nombre: _nombreController.text,
              origen: _origenController.text,
            );
            var id = await _saveVisitante(v);

            if (id > 0) {
              //Se verifica si el item ya existe para no remplazarlo con uno nuevo
              if (widget.itemToUpdate == null) {
                v.visId = id;
                widget.onAgregarItem(v);
              } else {
                // Update existing item
                widget.itemToUpdate!.visId = _visitanteId;
                widget.itemToUpdate!.nombre = _nombreController.text;
                widget.itemToUpdate!.origen = _origenController.text;

                widget.onAgregarItem(widget.itemToUpdate!);
              }
            }
          },
          child: Icon(widget.itemToUpdate == null
              ? CupertinoIcons.add_circled
              : CupertinoIcons.check_mark_circled),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    const Text('Nombre:'),
                    CupertinoTextField(
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 8),
                    // Origen
                    const Text('Origen:'),
                    CupertinoTextField(
                      controller: _origenController,
                      textInputAction: TextInputAction.next,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
