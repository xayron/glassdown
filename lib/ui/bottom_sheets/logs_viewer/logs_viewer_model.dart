import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';

class LogsViewerModel extends ReactiveViewModel {
  final _logs = locator<LogsService>();

  String _log = 'No logs';
  String get log => _log;

  Future<void> getLogs() async {
    try {
      _log = await _logs.getLogs();
      rebuildUi();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
    }
  }
}
