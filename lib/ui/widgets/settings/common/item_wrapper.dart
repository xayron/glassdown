import 'package:flutter/material.dart';

class ItemWrapper extends StatelessWidget {
  const ItemWrapper({
    super.key,
    required this.mainText,
    this.secondaryText,
    this.trailingWidget,
    this.enabled = true,
    this.threeLined = false,
  });

  final String mainText;
  final String? secondaryText;
  final Widget? trailingWidget;
  final bool enabled;
  final bool threeLined;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      isThreeLine: threeLined,
      enabled: enabled,
      title: Text(
        mainText,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
        ),
      ),
      subtitle: secondaryText != null
          ? Text(
              secondaryText!,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              ),
            )
          : null,
      trailing: trailingWidget,
    );
  }
}
