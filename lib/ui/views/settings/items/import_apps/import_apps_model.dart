import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ImportAppsModel extends BaseViewModel {
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();

  Future<void> importApps() async {
    try {
      await _apps.importAppList();
      _snackbar.showCustomSnackBar(
        title: 'Apps',
        message: 'App list imported',
        variant: SnackbarType.info,
      );
    } catch (e) {
      _snackbar.showCustomSnackBar(
        title: 'Error',
        message: e is IOError ? e.message : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
