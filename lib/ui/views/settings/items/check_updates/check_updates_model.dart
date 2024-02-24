import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/services/updater_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/updater/update_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckUpdatesModel extends BaseViewModel {
  final _updater = locator<UpdaterService>();
  final _snackbar = locator<SnackbarService>();

  Future<void> checkUpdates() async {
    try {
      final result = await _updater.checkUpdates();
      if (result) {
        showUpdaterSheet();
      } else {
        _snackbar.showCustomSnackBar(
          title: 'Info',
          message: 'No updates available.',
          variant: SnackbarType.info,
        );
      }
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'checkUpdates',
        e.toString(),
      );
    }
  }
}
