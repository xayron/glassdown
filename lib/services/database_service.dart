import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/database/app_info_table.dart';
import 'package:glass_down_v2/services/db_interface.dart';

class DatabaseService implements IDatabase<AppInfoItem> {
  @override
  Future<int> addApp(VersionLink appData, String? imageUrl) {
    // TODO: implement addApp
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllApps() {
    // TODO: implement deleteAllApps
    throw UnimplementedError();
  }

  @override
  Future<int> editApp(VersionLink appData, String? imageUrl, AppInfo app) {
    // TODO: implement editApp
    throw UnimplementedError();
  }

  @override
  Future<List<AppInfoItem>> getAllApps() {
    // TODO: implement getAllApps
    throw UnimplementedError();
  }

  @override
  Future<List<AppInfoItem>> importApps(List<AppInfo> apps) {
    // TODO: implement importApps
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    throw UnimplementedError("This won't be needed");
  }

  @override
  Future<bool> removeApp(AppInfo app) {
    // TODO: implement removeApp
    throw UnimplementedError();
  }
}
