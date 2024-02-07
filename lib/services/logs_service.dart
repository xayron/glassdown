import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LogsService {
  Future<IOError?> exportLogs() async {
    try {
      final Directory documentsDir = Directory('/storage/emulated/0/Documents');
      final appDataDir = await getExternalStorageDirectory();
      final Directory dir = Directory('${appDataDir?.path}/Logs');

      if (!dir.existsSync()) {
        throw IOError("There's no log to export so far");
      }
      final List<File> fileList = dir.listSync().whereType<File>().toList();
      if (fileList.isEmpty) {
        throw IOError("There's no log to export so far");
      }

      final zipFile = File(
        "${documentsDir.path}/GlassDownLogs_${DateFormat('dd_MM_yyyy-HH_mm').format(DateTime.now())}.zip",
      );
      await ZipFile.createFromDirectory(
        sourceDir: dir,
        zipFile: zipFile,
      );

      FlutterLogs.logInfo(
        runtimeType.toString(),
        'exportLogs',
        'Logs zipped into ${zipFile.path}',
      );

      return null;
    } catch (e) {
      FlutterLogs.logError(runtimeType.toString(), 'exportLogs', e.toString());
      if (e is IOError) {
        return e;
      }
      return IOError(e.toString());
    }
  }

  Future<IOError?> deleteLogs() async {
    try {
      final appDataDir = await getExternalStorageDirectory();
      final Directory dir = Directory('${appDataDir?.path}/Logs');

      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }

      return null;
    } catch (e) {
      FlutterLogs.logError(runtimeType.toString(), 'deleteLogs', e.toString());
      if (e is IOError) {
        return e;
      }
      return IOError(e.toString());
    }
  }
}
