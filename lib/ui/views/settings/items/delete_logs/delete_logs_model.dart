import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteLogsModel extends BaseViewModel {
  final _logs = locator<LogsService>();
  final _snackbar = locator<SnackbarService>();

  Future<void> deleteLogs() async {
    try {
      await _logs.deleteLogs();
      _snackbar.showCustomSnackBar(
        message: 'Logs deleted',
        variant: SnackbarType.info,
      );
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is IOError ? e.message : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
