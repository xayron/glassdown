import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class AboutAppDialogModel extends BaseViewModel {
  final _settings = locator<SettingsService>();
  final message =
      'This app helps you to download APK files directly from APKMirror, without tedious clicking.';

  AppPackageInfo? _info;
  AppPackageInfo? get info => _info;

  String get version => info?.version ?? 'Loading...';

  Future<void> getPackageInfo() async {
    _info = await _settings.getPackageInfo();
    rebuildUi();
  }
}
