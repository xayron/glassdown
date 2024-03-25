import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/logs_viewer/logs_viewer.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShowLogsModel extends BaseViewModel {
  final _logs = locator<LogsService>();
  final _snackbar = locator<SnackbarService>();

  Future<void> showLogsViewer() async {
    try {
      final logsDir = await _logs.getLogsDir();
      if (_logs.areLogsPresent(logsDir)) {
        showLogsViewSheet();
      } else {
        _snackbar.showCustomSnackBar(
          message: 'No logs to show',
          variant: SnackbarType.info,
        );
      }
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
    }
  }
}
