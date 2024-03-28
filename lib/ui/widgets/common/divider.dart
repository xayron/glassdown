import 'package:flutter/material.dart';

class ItemDivider extends StatelessWidget {
  const ItemDivider({super.key, this.indent = 12});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.0,
      indent: indent,
      endIndent: indent,
    );
  }
}
