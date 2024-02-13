import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/database/app_info_model.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:isar/isar.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService implements InitializableDependency {
  late final Isar _db;

  @override
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _db = await Isar.open(
      [AppInfoModelSchema],
      directory: dir.path,
    );
  }

  Future<List<AppInfoModel>> getAllApps() async {
    try {
      return _db.appInfoModels.where().sortByName().findAll();
    } catch (e) {
      const message = 'Getting apps failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }

  Future<int> addApp(VersionLink appData, String? imageUrl) async {
    try {
      final result = await _db.writeTxn<int>(() async {
        final newApp = AppInfoModel()
          ..name = appData.name
          ..appUrl = appData.url
          ..logoUrl = imageUrl;
        return await _db.appInfoModels.put(newApp);
      });
      return result;
    } catch (e) {
      const message = 'Adding app failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }

  Future<int> editApp(
    VersionLink appData,
    String? imageUrl,
    AppInfo app,
  ) async {
    try {
      final editedApp = await _db.appInfoModels.get(app.dbId);
      if (editedApp == null) {
        throw DbError('Cannot get existing app from db');
      }
      final result = await _db.writeTxn<int>(() async {
        editedApp
          ..name = appData.name
          ..appUrl = appData.url
          ..logoUrl = imageUrl;
        return await _db.appInfoModels.put(editedApp);
      });
      return result;
    } catch (e) {
      const message = 'Adding app failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<List<AppInfoModel>> importApps(List<AppInfo> apps) async {
    final List<AppInfoModel> models = [];
    for (final app in apps) {
      final appModel = AppInfoModel()
        ..name = app.name
        ..appUrl = app.appUrl
        ..logoUrl = app.imageUrl;
      models.add(appModel);
    }
    final ids = await _db.writeTxn<List<int>>(() async {
      return await _db.appInfoModels.putAll(models);
    });
    for (int i = 0; i < models.length; i++) {
      models[i].id = ids[i];
    }
    return models;
  }

  Future<bool> removeApp(AppInfo app) async {
    try {
      return await _db.writeTxn<bool>(() async {
        return await _db.appInfoModels.delete(app.dbId);
      });
    } catch (e) {
      const message = 'Removing app failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }

  Future<void> deleteAllApps() async {
    try {
      await _db.writeTxn(() async => await _db.clear());
    } catch (e) {
      const message = 'Removing app failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }
}
