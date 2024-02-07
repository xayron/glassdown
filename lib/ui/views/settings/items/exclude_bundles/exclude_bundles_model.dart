import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class ExcludeBundlesModel extends BaseViewModel {
  bool get excludeBundles => _settings.excludeBundles;

  final _settings = locator<SettingsService>();

  void updateValue(bool value) {
    _settings.setExcludeBundles(value);
    rebuildUi();
  }
}
