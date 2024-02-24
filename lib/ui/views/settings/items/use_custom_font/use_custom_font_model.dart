import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class UseCustomFontModel extends BaseViewModel {
  final _settings = locator<SettingsService>();
  bool get useImportedFont => _settings.useImportedFont;

  void updateValue(bool value) {
    _settings.setUseImportedFont(value);
    rebuildUi();
  }
}
