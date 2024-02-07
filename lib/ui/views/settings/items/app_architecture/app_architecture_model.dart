import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class AppArchitectureModel extends BaseViewModel {
  Architecture get architecture => _settings.architecture;

  final controller = MenuController();

  void handleTap() {
    if (!controller.isOpen) {
      controller.open();
    }
  }

  final _settings = locator<SettingsService>();

  void updateValue(Architecture arch, int index) {
    final archIndex = Architecture.values.elementAt(index);
    _settings.setArchitecture(archIndex);
    rebuildUi();
  }

  String menuName(String currentName) {
    return currentName.padRight(21);
  }
}
