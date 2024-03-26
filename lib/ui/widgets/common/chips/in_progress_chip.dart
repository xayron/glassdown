import 'package:flutter/material.dart';

class InProgressChip extends StatelessWidget {
  const InProgressChip({super.key, this.progressValue});

  final String? progressValue;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(progressValue ?? 'IN PROGRESS'),
      backgroundColor: Colors.amber,
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      side: BorderSide.none,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
