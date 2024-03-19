import 'package:drift/drift.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/database_service.dart';
import 'package:glass_down_v2/services/local_db_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';

class MigrationService {
  final _oldDb = locator<LocalDbService>();
  final _newDb = locator<DatabaseService>();
  final _settings = locator<SettingsService>();

  Future<bool> runMigration() async {
    try {
      final result = await _oldDb.getAllApps();
      final entities = result.map((e) {
        return AppInfoItemCompanion.insert(
          name: e.name,
          appUrl: e.appUrl,
          logoUrl: Value.ofNullable(e.logoUrl),
        );
      }).toList();
      await _newDb.migrateFromOldDb(entities);
      return true;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        'Failed to run migration',
      );
      rethrow;
    }
  }

  void setMigrationComplete() {
    _settings.setHasMigratedDb(true);
  }
}
