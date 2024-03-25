import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/versions/versions_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppCardModel extends BaseViewModel {
  final _navigation = locator<NavigationService>();
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  void openVersionsView(AppInfo app) {
    if (!_settings.isConnected) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: 'You have no internet connection',
      );
      return;
    }
    _navigation.navigateWithTransition(
      VersionsView(app: app),
      preventDuplicates: false,
    );
  }

  Future<void> dismissApp(AppInfo app) async {
    _snackbar.showCustomSnackBar(
      message: '${app.name} deleted',
      variant: SnackbarType.info,
      duration: const Duration(seconds: 3),
      mainButtonTitle: 'Undo',
      onMainButtonTapped: () async {
        _snackbar.showCustomSnackBar(
          message: 'Restoring app...',
          variant: SnackbarType.progress,
        );
        await _apps.addApp((name: app.name, url: app.appUrl));
        rebuildUi();
      },
    );
    await _apps.removeApp(app);
  }
}
