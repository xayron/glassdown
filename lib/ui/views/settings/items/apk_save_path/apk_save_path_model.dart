import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ApkSavePathModel extends BaseViewModel {
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  bool _storageStatus = false;
  bool get storageStatus => _storageStatus;

  Future<void> getStoragePermissionStatus() async {
    try {
      _storageStatus = await _settings.storageGranted();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is IOError ? e.message : "Can't pick this folder",
        variant: SnackbarType.info,
      );
    }
  }

  String get exportApkPath {
    if (_settings.apkSavePath.length <= 20) {
      return 'Main Storage';
    }
    return _settings.apkSavePath.substring(20);
  }

  Future<void> pickFolder(BuildContext context) async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result == null) {
        throw IOError('Path has not been picked');
      }
      final testDir = Directory(result);
      final testFile = File('${testDir.path}/test.txt');
      testFile.createSync();
      testFile.deleteSync();
      _settings.setApkSavePath(result);
      _snackbar.showCustomSnackBar(
        message: 'Path saved succesfully',
        variant: SnackbarType.info,
      );
      rebuildUi();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        'Cannot write to this folder',
      );
      _snackbar.showCustomSnackBar(
        message: e is IOError ? e.message : "Can't pick this folder",
        variant: SnackbarType.info,
      );
    }
  }
}
