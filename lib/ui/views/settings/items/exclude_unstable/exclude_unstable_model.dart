import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class ExcludeUnstableModel extends BaseViewModel {
  bool get excludeUnstable => _settings.excludeUnstable;

  final _settings = locator<SettingsService>();

  void updateValue(bool value) {
    _settings.setExcludeUnstable(value);
    rebuildUi();
  }
}
