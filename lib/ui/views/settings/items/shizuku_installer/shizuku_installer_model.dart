import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:shizuku_apk_installer/shizuku_apk_installer.dart';
import 'package:stacked/stacked.dart';

class ShizukuInstallerModel extends BaseViewModel {
  bool get shizukuEnabled => _settings.shizuku;

  final _settings = locator<SettingsService>();

  String? _status;
  String? get status => _status;

  bool shizukuAvailable() {
    if (_status != null) {
      if (!_status!.contains('binder_not_found')) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> updateValue(bool value) async {
    _status = await ShizukuApkInstaller.checkPermission();
    FlutterLogs.logInfo(
      runtimeType.toString(),
      getFunctionName(),
      'Shizuku status: ${_status ?? 'invalid'}',
    );
    if (_status != null) {
      if (_status!.contains('granted')) {
        _settings.setShizuku(value);
        rebuildUi();
        return;
      } else {
        _settings.setShizuku(false);
        rebuildUi();
        return;
      }
    }
    _settings.setShizuku(false);
    rebuildUi();
  }
}
