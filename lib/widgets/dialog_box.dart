import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
    BuildContext context, String message, VoidCallback yes, VoidCallback no) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: no,
            // onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: yes,
            // onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
