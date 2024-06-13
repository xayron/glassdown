import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class DisableUpdatesModel extends BaseViewModel {
  final _settings = locator<SettingsService>();

  bool get disableUpdates => _settings.disableUpdates;

  void updateValue(bool value) {
    _settings.setDisableUpdates(value);
    rebuildUi();
  }
}
