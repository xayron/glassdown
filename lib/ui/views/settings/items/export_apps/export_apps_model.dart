import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExportAppsModel extends ReactiveViewModel {
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  String get exportAppsPath {
    if (_settings.exportAppsPath.length <= 20) {
      return 'Main Storage';
    }
    return _settings.exportAppsPath.substring(20);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];

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
      _settings.setExportAppsPath(result);
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

  void exportApps() {
    try {
      _apps.exportAppList();
      _snackbar.showCustomSnackBar(
        message: 'App list exported',
        variant: SnackbarType.info,
      );
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is IOError ? e.message : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
