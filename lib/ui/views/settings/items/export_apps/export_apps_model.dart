import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExportAppsModel extends BaseViewModel {
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();

  void exportApps() {
    try {
      _apps.exportAppList();
      _snackbar.showCustomSnackBar(
        title: 'Apps',
        message: 'App list exported',
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
