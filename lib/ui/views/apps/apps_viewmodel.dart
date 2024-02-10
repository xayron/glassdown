import 'package:glass_down_v2/app/app.bottomsheets.dart';
import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/updater_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppsViewModel extends ReactiveViewModel {
  final _dialogService = locator<DialogService>();
  final _appsService = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();
  final _sheet = locator<BottomSheetService>();
  final _updater = locator<UpdaterService>();

  List<AppInfo> get apps => _appsService.apps;

  @override
  List<ListenableServiceMixin> get listenableServices => [_appsService];

  Future<void> checkUpdates() async {
    if (_updater.updateData == null) {
      return;
    }
    final result = await _updater.checkUpdates();
    if (result) {
      await showUpdateDialog();
    }
  }

  Future<void> showUpdateDialog() async {
    await _sheet.showCustomSheet(
      variant: BottomSheetType.updater,
    );
  }

  Future<void> showDialog() async {
    try {
      final response =
          await _dialogService.showCustomDialog<VersionLink?, void>(
        variant: DialogType.addApp,
      );
      if (response != null && response.data != null) {
        _snackbar.showCustomSnackBar(
          title: 'App',
          message: 'Saving app, please wait...',
          variant: SnackbarType.progress,
        );
        await _appsService.addApp(response.data!);
      }
      rebuildUi();
    } catch (e) {
      _snackbar.showSnackbar(
        title: 'Error',
        message: 'App already exists',
      );
    }
  }

  Future<void> allApps() async {
    await _appsService.loadAppsFromDb();
    rebuildUi();
  }
}
