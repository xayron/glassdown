import 'package:flutter/material.dart';

class TrailingDropdown<T> extends StatelessWidget {
  const TrailingDropdown({
    super.key,
    required this.initValue,
    required this.onSelected,
    required this.items,
    this.enabled = true,
  });

  final T? initValue;
  final void Function(T? value)? onSelected;
  final List<DropdownMenuEntry<T>> items;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: initValue,
      enabled: enabled,
      onSelected: onSelected,
      dropdownMenuEntries: items,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: InputBorder.none,
      ),
    );
  }
}
