import 'package:flutter/cupertino.dart';

// Muestra un dialogo de alerta
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
// Muestra modal de confirmación
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