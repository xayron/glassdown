import 'dart:io';

import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:path_provider/path_provider.dart';

class PathsService {
  Future<Directory> getFolderToSave() async {
    try {
      Directory? downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir = await getExternalStorageDirectory();
        if (downloadsDir == null) {
          throw IOError('Failed to obtain directory to save');
        }
      }

      return downloadsDir;
    } catch (e) {
      rethrow;
    }
  }
}
