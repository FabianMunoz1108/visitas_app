import 'package:flutter/cupertino.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/models/visitante_model.dart';
import 'package:visitas_app/services/persona_service.dart';
import 'package:visitas_app/services/reunion_service.dart';
import 'package:visitas_app/services/visitante_service.dart';
import 'package:visitas_app/utils/alert.dart';

class AgregarReunion extends StatefulWidget {
  //Item especifico para edición
  final ReunionModel? itemToUpdate;
  final Function(ReunionModel) onAgregarItem;

  const AgregarReunion(
      {super.key, required this.onAgregarItem, required this.itemToUpdate});

  @override
  State<AgregarReunion> createState() => _AgregarReunionState();
}

class _AgregarReunionState extends State<AgregarReunion> {
  final _lugarController = TextEditingController(text: "");
  final _reuService = ReunionService();
  final _perService = PersonaService();
  final _visService = VisitanteService();

  late DateTime _fecha;
  late List<PersonaModel> _personas;
  late List<VisitanteModel> _visitantes;
  int _reunionId = 0;
  bool _isLoading = true;
  double _duracion = 0.0;
  int _personaSeleccionada = 0;
  int _visitanteSeleccionado = 0;

  @override
  void initState() {
    //La llamada a super debe ser la primera en el método
    super.initState();
    _obtenerCatalogos();

    if (widget.itemToUpdate != null) {
      _reunionId = widget.itemToUpdate!.reuId;
      _duracion = widget.itemToUpdate!.duracion.toDouble();
      _lugarController.text = widget.itemToUpdate!.lugar;
      _personaSeleccionada = widget.itemToUpdate!.perId;
      _visitanteSeleccionado = widget.itemToUpdate!.visId;

      //parsear la fecha
      _fecha = DateTime.parse(widget.itemToUpdate!.horario);
    } else {
      _fecha = DateTime.now();
    }
    _personas = [];
    _visitantes = [];
  }

  //Obtiene lista de personas y visitantes
  void _obtenerCatalogos() async {
    try {
      final personas = await _perService.getPersonas();
      final visitantes = await _visService.getVisitantes();

      setState(() {
        _personas = personas;
        _visitantes = visitantes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las personas: $e');
    }
  }

  //Guarda o actualiza una reunión
  Future<int> _saveReunion(ReunionModel model) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var id = 0;
      if (model.reuId > 0) {
        id = await _reuService.putReunion(model);
      } else {
        id = await _reuService.postReunion(model);
      }
      return id;
    } catch (e) {
      showAlertDialog(context,
          title: 'Error', content: 'Ocurrió un error al guardar la reunión');

      print('Error al guardar la reunión: $e  ');
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
            ? 'Agregar Reunión'
            : 'Actualizar Reunión'),
        trailing:
            //Inicio boton de guardar
            CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            // Elemento a guardar o actualizar
            var r = ReunionModel(
              reuId: _reunionId,
              lugar: _lugarController.text,
              duracion: _duracion.toInt(),
              horario: _fecha.toIso8601String(),
              perId: _personaSeleccionada,
              visId: _visitanteSeleccionado,
            );
            var id = await _saveReunion(r);

            if (id > 0) {
              //Se verifica si el item ya existe para no remplazarlo con uno nuevo
              if (widget.itemToUpdate == null) {
                r.reuId = id;
                widget.onAgregarItem(r);
              } else {
                // Actualiza el item en la lista sin remplazarlo
                widget.itemToUpdate!.reuId = _reunionId;
                widget.itemToUpdate!.lugar = _lugarController.text;
                widget.itemToUpdate!.duracion = _duracion.toInt();
                widget.itemToUpdate!.horario = _fecha.toIso8601String();
                widget.itemToUpdate!.perId = _personaSeleccionada;
                widget.itemToUpdate!.visId = _visitanteSeleccionado;

                widget.onAgregarItem(widget.itemToUpdate!);
              }
            }
          },
          child: Icon(widget.itemToUpdate == null
              ? CupertinoIcons.add_circled
              : CupertinoIcons.check_mark_circled),
        ),
        //Fin boton de guardar
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Inicio lugar de la reunión
              const Text('Lugar:'),
              CupertinoTextField(
                controller: _lugarController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              //Fin lugar de la reunión

              //Inicio duración de la reunión
              Text('Duración: ${_duracion.toStringAsFixed(0)} hr(s)'),
              Row(children: [
                Expanded(
                  child: CupertinoSlider(
                    min: 0,
                    max: 8,
                    divisions: 10,
                    value: _duracion,
                    onChanged: (value) {
                      setState(() {
                        _duracion = value;
                      });
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              //Fin duración de la reunión

              //Inicio fecha de la reunión
              const Text('Fecha:'),
              CupertinoButton(
                onPressed: () {
                  showDateDialog(
                    context,
                    CupertinoDatePicker(
                      initialDateTime: _fecha,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _fecha = newDateTime;
                        });
                      },
                    ),
                  );
                },
                child: Text(
                    //formatear la fecha
                    '${_fecha.day}/${_fecha.month}/${_fecha.year}'),
              ),
              const SizedBox(height: 8),
              //Fin fecha de la reunión

              //Inicio visitante
              const Text('Visitante:'),
              if (_isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoPicker(
                  itemExtent: 32,
                  // Selecciona el visitante que se está actualizando
                  scrollController: FixedExtentScrollController(
                    initialItem: widget.itemToUpdate != null
                        ? _visitantes.indexWhere((visitante) =>
                            visitante.visId == _visitanteSeleccionado)
                        : 0,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _visitanteSeleccionado = _visitantes[index].visId;
                      print(
                          'Visitante seleccionado: ${_visitantes[index].nombre}');
                    });
                  },
                  children: _visitantes.map((e) => Text(e.nombre)).toList(),
                ),
              const SizedBox(height: 8),
              //Fin visitante

              //Inicio persona a quién visita
              const Text('Persona a quién visita:'),
              if (_isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoPicker(
                  itemExtent: 32,
                  // Selecciona la persona que se está actualizando
                  scrollController: FixedExtentScrollController(
                    initialItem: widget.itemToUpdate != null
                        ? _personas.indexWhere(
                            (persona) => persona.perId == _personaSeleccionada)
                        : 0,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _personaSeleccionada = _personas[index].perId;
                      print('Persona seleccionada: ${_personas[index].nombre}');
                    });
                  },
                  children: _personas.map((e) => Text(e.nombre)).toList(),
                ),
              const SizedBox(height: 8),
              //Fin persona a quién visita
            ],
          ),
        ),
      ),
    );
  }
}
