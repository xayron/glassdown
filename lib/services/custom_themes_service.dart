import 'package:flutter/material.dart';

enum MainColor { blue, red, purple, orange, indigo }

typedef ColorNamed = ({Color color, String name});

class ThemeScheme {
  ThemeScheme(this.color, this.name)
      : lightScheme = ColorScheme.fromSeed(seedColor: color),
        darkScheme = ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.dark,
        );

  final String name;
  final Color color;
  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
}

class CustomThemesService {
  CustomThemesService() {
    for (final color in _colorList) {
      _themeList.add(ThemeScheme(color.color, color.name));
    }
  }

  final List<ColorNamed> _colorList = [
    (color: Colors.blue, name: 'blue'),
    (color: Colors.red, name: 'red'),
    (color: Colors.purple, name: 'purple'),
    (color: Colors.orange, name: 'orange'),
    (color: Colors.indigo, name: 'indigo'),
  ];

  final List<ThemeScheme> _themeList = [];

  ThemeScheme getTheme(MainColor color) {
    return _themeList.firstWhere(
      (el) => el.name == color.name,
      orElse: () => _themeList[0],
    );
  }
}
