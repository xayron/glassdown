import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class OnlyUnstableModel extends ReactiveViewModel {
  final _settings = locator<SettingsService>();

  bool get onlyUnstable => _settings.onlyUnstable;
  bool get excludeUnstable => _settings.excludeUnstable;

  void updateValue(bool value) {
    _settings.setOnlyUnstable(value);
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];
}
