import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/services/visitas_service.dart';
import 'package:visitas_app/utils/alert.dart';

class AgregarPersona extends StatefulWidget {
  //Item especifico para edición
  final PersonaModel? itemToUpdate;
  final Function(PersonaModel) onAgregarItem;

  const AgregarPersona(
      {super.key, required this.onAgregarItem, required this.itemToUpdate});

  @override
  State<AgregarPersona> createState() => _AgregarPersonaState();
}

class _AgregarPersonaState extends State<AgregarPersona> {
  int _perId = 0;
  bool _isLoading = false;
  final _nombreController = TextEditingController(text: "");
  final _areaController = TextEditingController(text: "");

  @override
  void initState() {
    //La llamada a super debe ser la primera en el método
    super.initState();

    if (widget.itemToUpdate != null) {
      _perId = widget.itemToUpdate!.perId;
      _nombreController.text = widget.itemToUpdate!.nombre;
      _areaController.text = widget.itemToUpdate!.area;
    }
  }

  Future<int> _savePersona(PersonaModel p) async {
    var service = VisitasService();
    setState(() {
      _isLoading = true;
    });

    try {
      var id = 0;
      if (p.perId > 0) {
        id = await service.putPersona(p);
      } else {
        id = await service.postPersona(p);
      }
      return id;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al agregar la persona');

      print('Error al guardar la persona: $e  ');
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
            ? 'Agregar Persona'
            : 'Actualizar Persona'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            // Item to add or update
            var p = PersonaModel(
              perId: _perId,
              nombre: _nombreController.text,
              area: _areaController.text,
            );
            var id = await _savePersona(p);

            if (id > 0) {
              //Se verifica si el item ya existe para no remplazarlo con uno nuevo
              if (widget.itemToUpdate == null) {
                widget.onAgregarItem(p);
              } else {
                // Update existing item
                widget.itemToUpdate!.perId = _perId;
                widget.itemToUpdate!.nombre = _nombreController.text;
                widget.itemToUpdate!.area = _areaController.text;

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
                    // Área
                    const Text('Área:'),
                    CupertinoTextField(
                      controller: _areaController,
                      textInputAction: TextInputAction.next,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
