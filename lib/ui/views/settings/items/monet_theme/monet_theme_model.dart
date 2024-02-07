import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class MonetThemeModel extends BaseViewModel {
  bool get monetEnabled => _settings.monetEnabled;
  bool get supportMonet => _settings.supportMonet;

  final _settings = locator<SettingsService>();

  void updateValue(bool value) {
    _settings.setMonetEnabled(value);
    rebuildUi();
  }
}
