import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget alertDialog(BuildContext context, VoidCallback function) {
  return Consumer(builder: (context, ref, child) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.all(20),
        actionsPadding: const EdgeInsets.only(right: 10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
        content: const Center(
          child: Text(
            "Do You want to Delete?",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
              onPressed: function,
              child: const Text(
                "Okay",
                style: TextStyle(fontSize: 16),
              ))
        ]);
  });
}
