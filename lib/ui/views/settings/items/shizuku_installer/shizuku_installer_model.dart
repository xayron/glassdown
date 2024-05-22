import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class ShizukuInstallerModel extends BaseViewModel {
  bool get shizukuEnabled => _settings.shizuku;

  final _settings = locator<SettingsService>();

  void updateValue(bool value) {
    _settings.setShizuku(value);
    rebuildUi();
  }
}
