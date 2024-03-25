import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/app_info_minimal.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/database_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:stacked/stacked.dart';

class AppsService with ListenableServiceMixin {
  AppsService() {
    listenToReactiveValues([apps]);
  }

  final _db = locator<DatabaseService>();
  final _scraper = locator<ScraperService>();
  final _settings = locator<SettingsService>();
  final List<AppInfo> apps = [];

  void comparator() => apps.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

  List<AppInfoMinimal> _convertToMinimalAppList() {
    return apps
        .map((e) => AppInfoMinimal(e.name, e.appUrl, imageUrl: e.imageUrl))
        .toList();
  }

  Future<void> loadAppsFromDb() async {
    apps.clear();
    final dbApps = await _db.getAllApps();
    for (final app in dbApps) {
      apps.add(AppInfo(
        app.name,
        app.appUrl,
        [],
        app.id,
        imageUrl: app.logoUrl,
      ));
    }
    comparator();
  }

  Future<void> addApp(VersionLink appInfo) async {
    try {
      if (_checkIfAppExists(appInfo.url)) {
        throw DbError('App already exists');
      }
      final appImage = await _scraper.getAppImage(appInfo);
      final id = await _db.addApp(appInfo, appImage);
      apps.add(AppInfo(appInfo.name, appInfo.url, [], id, imageUrl: appImage));
      comparator();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is DbError ? e.message : e.toString(),
      );
      rethrow;
    }
  }

  Future<bool> editApp(VersionLink protoApp, AppInfo app) async {
    try {
      if (_checkIfAppExists(protoApp.url) && protoApp.url != app.appUrl) {
        return false;
      }
      final appImage = await _scraper.getAppImage(protoApp);
      await _db.editApp(protoApp, appImage, app);
      return true;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is DbError ? e.message : e.toString(),
      );
      rethrow;
    }
  }

  Future<void> removeApp(AppInfo app) async {
    try {
      await _db.removeApp(app);
      apps.removeWhere((element) => element.dbId == app.dbId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllApps() async {
    try {
      await _db.purgeApps();
      apps.clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<IOError?> exportAppList() async {
    try {
      final Directory exportDir = Directory(_settings.exportAppsPath);
      final appListPath = p.join(exportDir.path,
          'glass_down_apps-${DateFormat('dd_MM_yyyy-HH_mm').format(DateTime.now())}.json');

      if (!exportDir.existsSync()) {
        throw IOError('Cannot write to Downloads folder');
      }

      final minimalApps = _convertToMinimalAppList();
      final appList = minimalApps.map((e) => e.toMap()).toList();
      final exportList = File(appListPath);
      exportList.writeAsStringSync(jsonEncode(appList));

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

  Future<IOError?> importAppList() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['json'],
        dialogTitle: 'Pick file to import',
      );

      if (result == null) {
        throw IOError('No file picked');
      }

      final pickedFile = result.files.first;

      if (pickedFile.path == null) {
        throw IOError('No path for imported file exists');
      }

      final exportList = File(pickedFile.path!);

      final jsonString = exportList.readAsStringSync();
      final decodedJson = jsonDecode(jsonString);
      if (decodedJson is! List<dynamic>) {
        throw IOError('JSON has incorrect format');
      }

      final jsonMap = decodedJson.cast<Map<String, dynamic>>();
      final minimalApps =
          jsonMap.map((e) => AppInfoMinimal.fromMap(e)).toList();

      final models = await _db.importApps(minimalApps);

      for (final model in models) {
        apps.add(AppInfo(model.name, model.appUrl, [], model.id));
      }

      return null;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
      rethrow;
    }
  }

  bool _checkIfAppExists(String appUrl) {
    final findApp = apps.indexWhere((element) => element.appUrl == appUrl);
    return findApp != -1;
  }
}
