import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:shizuku_apk_installer/shizuku_apk_installer.dart';

class ShizukuInstallerModel extends BaseViewModel {
  bool get shizukuEnabled => _settings.shizuku;

  final _settings = locator<SettingsService>();

  String? _status;
  String? get status => _status;

  Future<void> checkShizukuStatus() async {
    _status = await ShizukuApkInstaller.checkPermission();
    rebuildUi();
  }

  String getStatus() {
    const description = 'Install APKs without interaction';
    final status = 'Status: $_status';
    return '$description\n$status';
  }

  void updateValue(bool value) {
    _settings.setShizuku(value);
    rebuildUi();
  }
}
