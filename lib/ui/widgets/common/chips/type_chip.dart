import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  const TypeChip({super.key, required this.isBundle});

  final bool isBundle;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(isBundle ? 'BUNDLE' : 'APK'),
      backgroundColor: isBundle ? Colors.lightGreenAccent : Colors.cyanAccent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      side: BorderSide.none,
      labelStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
      ),
    );
  }
}
