import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends ReactiveViewModel {
  final _settings = locator<SettingsService>();

  bool get devOptions => _settings.devOptions;

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];
}
