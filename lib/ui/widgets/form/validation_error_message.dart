import 'package:flutter/material.dart';

class ValidationErrorMessage extends StatelessWidget {
  const ValidationErrorMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
