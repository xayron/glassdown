import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteAppsModel extends BaseViewModel {
  final _apps = locator<AppsService>();
  final _snackbar = locator<SnackbarService>();

  Future<void> deleteApps() async {
    try {
      await _apps.deleteAllApps();
      rebuildUi();
      _snackbar.showCustomSnackBar(
        message: 'App list purged',
        variant: SnackbarType.info,
      );
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is DbError ? e.fullMessage() : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
