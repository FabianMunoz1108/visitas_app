import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/services/visitas_service.dart';

class AgregarReunion extends StatefulWidget {
  //Item especifico para edición
  final ReunionModel? itemToUpdate;
  final Function(ReunionModel) onAgregarItem;

  const AgregarReunion(
      {required this.onAgregarItem, required this.itemToUpdate});

  @override
  State<AgregarReunion> createState() => _AgregarReunionState();
}

class _AgregarReunionState extends State<AgregarReunion> {
  final _lugarController = TextEditingController(text: "");
  final _duracionController = TextEditingController(text: "1");
  
  late DateTime _fecha;
  late List<PersonaModel> _personas;
  late List<VisitanteModel> _visitantes;
  bool _isLoading = true;

  @override
  void initState() {
    //La llamada a super debe ser la primera en el método
    super.initState();
    _obtenerCatalogos();

    if (widget.itemToUpdate != null) {
      _lugarController.text = widget.itemToUpdate!.lugar;
    }

    _fecha = DateTime.now();
    _personas = [];
    _visitantes = [];
  }

  void _obtenerCatalogos() async {
    var service = VisitasService();

    try {
      final personas = await service.getPersonas();
      final visitantes = await service.getVisitantes();

      setState(() {
        _personas = personas;
        _visitantes = visitantes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las personas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.itemToUpdate == null
            ? 'Agregar Reunión'
            : 'Actualizar Reunión'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            //Se verifica si el item ya existe para no remplazarlo con uno nuevo
            if (widget.itemToUpdate == null) {
              print("Nuevo item");

              widget.onAgregarItem(
                ReunionModel(
                  reuId: 0,
                  lugar: _lugarController.text,
                  horario: _fecha.toIso8601String(),
                  duracion: int.parse(_duracionController.text),
                  perId: 2,
                  visId: 1,
                ),
              );
            } else {
              print("Actualizar sin duplicar");

              // Update existing item
              widget.itemToUpdate!.lugar = _lugarController.text;

              widget.onAgregarItem(widget.itemToUpdate!);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
              const Text('Lugar:'),
              CupertinoTextField(
                controller: _lugarController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              const Text('Fecha:'),

              const SizedBox(height: 8),
              const Text('Duración en horas:'),
              CupertinoTextField(
                controller: _duracionController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 8),
              const Text('Visitante:'),
              FutureBuilder<List<VisitanteModel>>(
                future: Future.value(_visitantes),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  } else {
                    return CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (index) {
                        print('Visitante seleccionado: ${_visitantes[index].nombre}');
                      },
                      children: snapshot.data!
                          .map((e) => Text(e.nombre))
                          .toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              const Text('Persona a quién visita:'),
              if (_isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (index) {
                    print('Persona seleccionada: ${_personas[index].nombre}');
                  },
                  children: _personas
                      .map((e) => Text(e.nombre))
                      .toList(),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
