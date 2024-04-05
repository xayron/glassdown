import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LogsService {
  final _settings = locator<SettingsService>();

  Future<Directory> getLogsDir() async {
    final appDataDir = await getExternalStorageDirectory();
    return Directory('${appDataDir?.path}/Logs');
  }

  bool areLogsPresent(Directory dir) {
    if (!dir.existsSync()) {
      return false;
    }
    final List<File> fileList = dir.listSync().whereType<File>().toList();
    if (fileList.isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<String>> getLogs() async {
    final dir = await getLogsDir();
    final List<File> fileList = dir.listSync().whereType<File>().toList();
    final todaysLog = fileList.firstWhere((element) {
      final logFileName = element.path.split('/').last;
      final todaysDateFormatted = DateFormat('ddMMyyyy').format(DateTime.now());
      if (logFileName.startsWith(todaysDateFormatted)) {
        return true;
      }
      return false;
    });
    final logContent = todaysLog.readAsLinesSync();
    return logContent;
  }

  Future<IOError?> exportLogs() async {
    try {
      final Directory documentsDir = Directory(_settings.exportLogsPath);

      final dir = await getLogsDir();

      final logsPresent = areLogsPresent(dir);

      if (!logsPresent) {
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
        getFunctionName(),
        'Logs zipped into ${zipFile.path}',
      );

      return null;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
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
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
      if (e is IOError) {
        return e;
      }
      return IOError(e.toString());
    }
  }
}
