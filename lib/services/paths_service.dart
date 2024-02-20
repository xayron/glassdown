import 'dart:io';

import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/settings_service.dart';

class PathsService {
  final _settings = locator<SettingsService>();

  Future<Directory> getFolderToSave() async {
    try {
      Directory? downloadsDir = Directory(_settings.apkSavePath);
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync();
      }

      return downloadsDir;
    } catch (e) {
      throw IOError(e.toString());
    }
  }
}
