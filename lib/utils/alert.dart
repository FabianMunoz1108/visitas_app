import 'package:flutter/cupertino.dart';

// Esta función muestra un CupertinoAlertDialog con un título y un contenido, para notificar al usuario sobre un evento.
void showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el dialogo
            },
          ),
        ],
      );
    },
  );
}
// Esta función muestra un CupertinoActionSheet con una lista de acciones, para solicitar al usuario que seleccione una de ellas.
void showActionSheet(
  BuildContext context, {
  required String title,
  required List<String> actions,
  required Function(String) onSelected,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text(title),
        actions: actions
            .map(
              (action) => CupertinoActionSheetAction(
                child: Text(action),
                onPressed: () {
                  onSelected(action);
                  Navigator.of(context).pop(); // Cierre de la hoja de acción
                },
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(); // Cierra la hoja de acción
          },
          child: const Text('Cancelar'),
        ),
      );
    },
  );
}

  // Esta función muestra un CupertinoModalPopup con una altura fija razonable
  void showDateDialog(
    BuildContext context,
    Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // El margen inferior se proporciona para alinear el popup sobre la barra de navegación del sistema.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Proporciona un color de fondo para el popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        //Uso de un widget SafeArea para evitar superposiciones del sistema.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }