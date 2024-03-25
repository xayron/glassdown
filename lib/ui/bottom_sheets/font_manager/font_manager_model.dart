import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/services/font_importer_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FontManagerModel extends ReactiveViewModel {
  final _snackbar = locator<SnackbarService>();
  final _fontImporter = locator<FontImporterService>();
  final _settings = locator<SettingsService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];

  String get pickedFont => _settings.customFont;

  final List<String> fontsList = [];

  Future<void> pickFont(String fontName) async {
    try {
      if (fontName == 'Default') {
        _settings.setUseImportedFont(false);
        _settings.setCustomFont(fontName);
        return;
      }
      _settings.setUseImportedFont(true);
      await _fontImporter.loadFonts(pickedFont);
      _settings.setCustomFont(fontName);
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: "Can't pick font",
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> getFontList() async {
    try {
      final result = await _fontImporter.getFontList();
      if (result != null) {
        fontsList.addAll(result);
      }
      rebuildUi();
    } catch (e) {
      const message = "Couldn't load fonts from storage";
      _snackbar.showCustomSnackBar(
        message: message,
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> deleteFont(String fontName) async {
    try {
      final result = await _fontImporter.deleteFont(fontName);
      if (result) {
        fontsList.remove(fontName);
        rebuildUi();
        return;
      }
      throw Error();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: "Can't delete font",
        variant: SnackbarType.info,
      );
    }
  }
}
