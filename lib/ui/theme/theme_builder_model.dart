import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/custom_themes_service.dart';
import 'package:glass_down_v2/services/font_importer_service.dart';
import 'package:glass_down_v2/services/migration_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class ThemeBuilderModel extends ReactiveViewModel {
  final _settings = locator<SettingsService>();
  final _themes = locator<CustomThemesService>();
  final _fontImporter = locator<FontImporterService>();
  final _migrator = locator<MigrationService>();

  ThemeMode get themeMode => _settings.themeMode;
  bool get monetEnabled => _settings.monetEnabled;
  MainColor get customTheme => _settings.customColor;
  bool get useImportedFont => _settings.useImportedFont;

  ThemeScheme getTheme(MainColor color) {
    return _themes.getTheme(color);
  }

  Future<void> loadCustomFont() async {
    await _fontImporter.loadFonts();
  }

  Future<void> migrateData() async {
    print(_settings.hasMigratedDb);
    if (_settings.hasMigratedDb) {
      return;
    }
    final result = await _migrator.runMigration();
    if (result) {
      _migrator.setMigrationComplete();
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];
}
