import 'package:flutter/material.dart';

class PlaceholderText extends StatelessWidget {
  const PlaceholderText({super.key, required this.text});

  final List<String> text;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (final fragment in text)
            Text(
              fragment,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              ),
            ),
        ],
      ),
    );
  }
}
