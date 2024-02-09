import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class DeleteOldVersionsModel extends BaseViewModel {
  final _settings = locator<SettingsService>();

  bool get autoRemove => _settings.autoRemove;

  void updateValue(bool value) {
    _settings.setAutoRemove(value);
    rebuildUi();
  }
}
