import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.router.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/models/errors/app_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/revanced_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/services/updater_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/add_app/add_app.dart';
import 'package:glass_down_v2/ui/bottom_sheets/updater/update_sheet.dart';
import 'package:glass_down_v2/ui/transition/custom_transitions.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppsViewModel extends StreamViewModel {
  final _dialogService = locator<DialogService>();
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();
  final _updater = locator<UpdaterService>();
  final _nav = locator<NavigationService>();
  final _settings = locator<SettingsService>();
  final _revanced = locator<RevancedService>();

  List<AppInfo> get apps => _apps.apps;

  bool _loading = false;
  bool get loading => _loading;

  @override
  List<ListenableServiceMixin> get listenableServices => [_apps];

  @override
  void onData(data) {
    super.onData(data);
    if (data != null && data is InternetStatus) {
      switch (data) {
        case InternetStatus.connected:
          _settings.setConnectionStatus(true);
        case InternetStatus.disconnected:
          _settings.setConnectionStatus(false);
      }
    }
  }

  @override
  Stream<InternetStatus> get stream => InternetConnection().onStatusChange;

  Future<void> showSettings() async {
    await _nav.navigateTo(
      Routes.settingsView,
      transition: CustomTransitions.fadeThrough,
    );
    await allApps();
  }

  Future<void> showRevancedIntegration() async {
    await _nav.navigateTo(
      Routes.revancedIntegrationView,
      transition: CustomTransitions.fadeThrough,
    );
    await allApps();
  }

  Future<void> checkUpdates() async {
    if (_updater.updateData != null) {
      return;
    }
    final result = await _updater.checkUpdates();
    if (result && !_updater.isDev && !_settings.disableUpdates) {
      showUpdaterSheet();
    }
  }

  Future<void> getLatestPatches() async {
    try {
      await _revanced.getLatestPatches();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is AppError ? e.fullMessage() : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> showAddDialog() async {
    try {
      await showAddAppSheet();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: 'App already exists',
      );
    }
  }

  Future<void> allApps() async {
    await _apps.loadAppsFromDb();
    rebuildUi();
  }

  Future<void> showEditDialog(AppInfo app) async {
    try {
      final response =
          await _dialogService.showCustomDialog<VersionLink?, AppInfo>(
        variant: DialogType.editApp,
        data: app,
      );
      _loading = true;
      rebuildUi();
      if (response != null && response.data != null) {
        final result = await _apps.editApp(response.data!, app);
        if (!result) {
          _snackbar.showCustomSnackBar(
            message: 'App already exists',
            variant: SnackbarType.info,
          );
        }
      }
      allApps();
      _loading = false;
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: e.toString(),
      );
    }
  }
}
