import 'package:flutter/material.dart';

class OkChip extends StatelessWidget {
  const OkChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text('OK'),
      backgroundColor: Colors.lightGreen,
      labelPadding: EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      side: BorderSide.none,
      labelStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
