import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/custom_themes_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class CustomThemeModel extends ReactiveViewModel {
  MainColor get customColor => _settings.customColor;

  bool get monetEnabled => _settings.monetEnabled;

  final _settings = locator<SettingsService>();

  final controller = MenuController();

  void handleTap() {
    if (!controller.isOpen) {
      controller.open();
    }
  }

  void updateValue(MainColor color, int index) {
    final colorIndex = MainColor.values.elementAt(index);
    _settings.setCustomColor(colorIndex);
    rebuildUi();
  }

  String menuName(String currentName) {
    return currentName.padRight(14);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];
}
