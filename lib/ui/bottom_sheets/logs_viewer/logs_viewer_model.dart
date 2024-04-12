import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';

class LogsViewerModel extends ReactiveViewModel {
  final _logs = locator<LogsService>();

  final List<String> log = [];

  Future<void> getLogs() async {
    try {
      final logLines = await _logs.getLogs();
      log.addAll(logLines);
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
