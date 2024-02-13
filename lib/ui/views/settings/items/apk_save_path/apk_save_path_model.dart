import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ApkSavePathModel extends BaseViewModel {
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  String get exportApkPath {
    if (_settings.apkSavePath.length <= 20) {
      return 'Main Storage';
    }
    return _settings.apkSavePath.substring(20);
  }

  Future<void> pickFolder(BuildContext context) async {
    try {
      final result = await FilesystemPicker.openDialog(
        context: context,
        rootDirectory: Directory('/storage/emulated/0'),
        fsType: FilesystemType.folder,
        contextActions: [FilesystemPickerNewFolderContextAction()],
      );
      if (result == null) {
        throw IOError('Path has not been picked');
      }
      final testDir = Directory(result);
      final testFile = File('${testDir.path}/test.txt');
      testFile.createSync();
      testFile.deleteSync();
      _settings.setApkSavePath(result);
      _snackbar.showCustomSnackBar(
        title: 'Info',
        message: 'Path saved succesfully',
        variant: SnackbarType.info,
      );
      rebuildUi();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'pickFolder',
        'Cannot write to this folder',
      );
      _snackbar.showCustomSnackBar(
        title: 'Error',
        message: e is IOError ? e.message : "Can't pick this folder",
        variant: SnackbarType.info,
      );
    }
  }
}
