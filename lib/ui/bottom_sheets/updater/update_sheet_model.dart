import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/update_error.dart';
import 'package:glass_down_v2/models/update_info.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/services/updater_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum PickedVersion { arm64, arm32 }

class UpdateSheetModel extends ReactiveViewModel {
  final _updater = locator<UpdaterService>();
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  final token = CancelToken();

  bool _installStatus = false;
  bool get installStatus => _installStatus;

  Future<void> canInstallPackages() async {
    try {
      _installStatus = await _settings.installGranted();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: "Cannot check install packages permission",
        variant: SnackbarType.info,
      );
    }
  }

  double get progress => _updater.downloadProgress;

  bool _started = false;
  bool get started => _started;

  UpdateInfo? updateInfo;
  PickedVersion pickedVersion = PickedVersion.arm64;

  void updateVersion(PickedVersion? value) {
    if (value != null) {
      pickedVersion = value;
      rebuildUi();
    }
  }

  void cancelUpdate() {
    if (_started) {
      token.cancel();
      _snackbar.showCustomSnackBar(
        message: 'Update canceled',
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> downloadUpdate() async {
    try {
      final version = pickedVersion == PickedVersion.arm64
          ? updateInfo!.arm64
          : updateInfo!.arm32;
      _started = true;
      notifyListeners();
      final result = await _updater.downloadUpdate(version, token);
      if (result != null) {
        if (!result) {
          _snackbar.showCustomSnackBar(
            message: 'Update package downloaded to $defaultDirPath',
            variant: SnackbarType.info,
          );
        }
      }
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is UpdateError ? e.message : e.toString(),
      );
    }
  }

  Future<void> checkUpdates() async {
    try {
      updateInfo = await _updater.getReleaseInfo();
      rebuildUi();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is UpdateError ? e.message : e.toString(),
      );
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_updater];
}
