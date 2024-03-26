import 'package:flutter/material.dart';

class NokChip extends StatelessWidget {
  const NokChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text('ERROR'),
      backgroundColor: Colors.redAccent,
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
