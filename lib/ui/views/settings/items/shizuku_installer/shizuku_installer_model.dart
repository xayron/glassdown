import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:shizuku_apk_installer/shizuku_apk_installer.dart';
import 'package:stacked/stacked.dart';

class ShizukuInstallerModel extends BaseViewModel {
  bool get shizukuEnabled => _settings.shizuku;

  final _settings = locator<SettingsService>();

  String? _status;
  String? get status => _status;

  bool get shizukuAvailable {
    if (_status != null) {
      if (!_status!.contains('binder_not_found')) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> checkShizukuStatus() async {
    _status = await ShizukuApkInstaller.checkPermission();
    rebuildUi();
  }

  String getStatus() {
    const description = 'Install APKs without interaction';
    final status = 'Status: $_status';
    String message = '';
    switch (_status) {
      case 'binder_not_found':
        message =
            'Shizuku binder not found, probably because Shizuku is not installed';
        break;
      case 'old_shizuku':
        message = 'Old Shizuku version (Android <11), user must update it';
      case 'granted_adb':
        message = 'Permission granted with ADB access';
      case 'granted_root':
        message = 'Permission granted with root access';
      case 'denied':
        message = 'Permission denied by user';
      case 'old_android_with_adb':
        message =
            'Unsupported, Shizuku running on Android < 8.1 with ADB, user must update Android or use root method';
      default:
        message = 'Invalid status';
    }
    return '$description\n$status\n$message';
  }

  Future<void> updateValue(bool value) async {
    _status = await ShizukuApkInstaller.checkPermission();
    print(status);
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
