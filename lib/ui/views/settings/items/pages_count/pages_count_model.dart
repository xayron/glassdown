import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class PagesCountModel extends BaseViewModel {
  int get pagesAmount => _settings.pagesAmount;

  final _settings = locator<SettingsService>();

  final controller = MenuController();

  void handleTap() {
    if (!controller.isOpen) {
      controller.open();
    }
  }

  void updateValue(int value) {
    _settings.setPagesAmount(value);
    rebuildUi();
  }

  String menuName(String currentName) {
    return currentName.padRight(13);
  }
}
