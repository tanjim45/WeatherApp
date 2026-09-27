import 'package:flutter/material.dart';

Future<dynamic> myDialog(BuildContext context, String msg) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          msg,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    },
  );
}
