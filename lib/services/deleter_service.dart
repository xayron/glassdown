import 'dart:io';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/settings_service.dart';

class DeleterService {
  final _settings = locator<SettingsService>();

  Future<IOError?> deleteOldVersions(AppInfo app) async {
    try {
      final Directory downloadsDir = Directory(_settings.apkSavePath);

      if (!downloadsDir.existsSync()) {
        throw IOError('Cannot write to Downloads folder');
      }

      final apkFiles = downloadsDir.listSync().whereType<File>().where(
        (element) {
          return element.path.split('.').last.contains('apk') &&
              element.path.contains(app.name);
        },
      );

      for (final file in apkFiles) {
        await file.delete();
      }

      return null;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'deleteOldVersions',
        e.toString(),
      );
      if (e is IOError) {
        return e;
      }
      return IOError(e.toString());
    }
  }
}
