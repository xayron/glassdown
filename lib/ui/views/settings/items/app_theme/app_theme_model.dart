import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class AppThemeModel extends BaseViewModel {
  ThemeMode get themeMode => _settings.themeMode;

  final _settings = locator<SettingsService>();

  final controller = MenuController();

  void handleTap() {
    if (!controller.isOpen) {
      controller.open();
    }
  }

  void updateValue(ThemeMode mode, int index) {
    final themeFromIndex = ThemeMode.values.elementAt(index);
    _settings.setThemeMode(themeFromIndex);
    rebuildUi();
  }

  String menuName(String currentName) {
    return currentName.padRight(14);
  }
}
