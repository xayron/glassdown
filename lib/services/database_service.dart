import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database_service.g.dart';

class AppInfoItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get appUrl => text()();
  TextColumn get logoUrl => text().nullable()();
}

@DriftDatabase(tables: [AppInfoItem])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}

class DatabaseService {
  final _db = AppDatabase();

  Future<List<AppInfoItemData>> getAllApps() async {
    try {
      return (_db.select(_db.appInfoItem)
            ..orderBy([
              (tbl) => OrderingTerm.desc(tbl.name),
            ]))
          .get();
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
    final appEntity = AppInfoItemCompanion.insert(
      name: appData.name,
      appUrl: appData.url,
      logoUrl: Value.ofNullable(imageUrl),
    );
    return await _db.into(_db.appInfoItem).insert(appEntity);
  }

  Future<int> editApp(
    VersionLink appData,
    String? imageUrl,
    AppInfo app,
  ) async {
    try {
      final appEntity = await (_db.select(_db.appInfoItem)
            ..where((tbl) => tbl.id.equals(app.dbId)))
          .getSingle();
      final editedApp = appEntity.copyWith(
        name: appData.name,
        appUrl: appData.url,
        logoUrl: Value.ofNullable(imageUrl),
      );
      return await _db.into(_db.appInfoItem).insertOnConflictUpdate(editedApp);
    } catch (e) {
      const message = 'Editing app failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<List<AppInfoItemData>> importApps(
      List<Map<String, dynamic>> appsJson) async {
    try {
      final importedApps = appsJson.map((e) => AppInfoItemData.fromJson(e));
      await _db.batch((batch) {
        batch.insertAll(
          _db.appInfoItem,
          importedApps,
          mode: InsertMode.insertOrReplace,
        );
      });
      return getAllApps();
    } catch (e) {
      const message = 'Importing apps failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }

  Future<void> migrateFromOldDb(List<AppInfoItemCompanion> entities) async {
    try {
      await _db.batch((batch) {
        batch.insertAll(
          _db.appInfoItem,
          entities,
        );
      });
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        'Error migrating apps',
      );
      rethrow;
    }
  }

  Future<List<String>> exportApps() async {
    final result = await (_db.select(_db.appInfoItem)).get();
    return result.map((e) => e.toJsonString()).toList();
  }

  Future<bool> removeApp(AppInfo app) async {
    try {
      await (_db.delete(_db.appInfoItem)
            ..where((tbl) => tbl.id.equals(app.dbId)))
          .go();
      return true;
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

  Future<void> purgeApps() async {
    try {
      await _db.delete(_db.appInfoItem).go();
    } catch (e) {
      const message = 'Purging apps failed';
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        '$message: ${e.toString()}',
      );
      throw DbError(message, e.toString());
    }
  }
}
