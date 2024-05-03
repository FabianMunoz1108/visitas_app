import 'package:flutter/cupertino.dart';

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
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

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
                  Navigator.of(context).pop(); // Close the action sheet
                },
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(); // Close the action sheet
          },
          child: const Text('Cancelar'),
        ),
      );
    },
  );
}