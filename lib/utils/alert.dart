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

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void showDateDialog(
    BuildContext context,
    Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }