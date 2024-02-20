import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/home/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PermissionsViewModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final _settings = locator<SettingsService>();

  final description =
      'Following permissions are required for the app to run. Click on the tile to enable them.';

  bool _storage = false;
  bool get storage => _storage;

  bool _install = false;
  bool get install => _install;

  Future<void> init() async {
    final storageGranted =
        await Permission.manageExternalStorage.status.isGranted;
    final installGranted =
        await Permission.requestInstallPackages.status.isGranted;
    _storage = storageGranted;
    _install = installGranted;
    rebuildUi();
  }

  Future<void> goHome() async {
    _nav.clearStackAndShowView(const HomeView());
  }

  Future<void> requestStoragePermission() async {
    final result = await Permission.manageExternalStorage.request();
    _storage = result.isGranted;
    rebuildUi();
  }

  Future<void> requestInstallPermission() async {
    final result = await Permission.requestInstallPackages.request();
    _install = result.isGranted;
    rebuildUi();
  }
}
