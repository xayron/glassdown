import 'package:glass_down_v2/models/app_info.dart';

abstract class IDatabase<T> {
  Future<int> addApp(VersionLink appData, String? imageUrl);

  Future<void> deleteAllApps();

  Future<int> editApp(VersionLink appData, String? imageUrl, AppInfo app);

  Future<List<T>> getAllApps();

  Future<List<T>> importApps(List<AppInfo> apps);

  Future<void> init();

  Future<bool> removeApp(AppInfo app);
}
