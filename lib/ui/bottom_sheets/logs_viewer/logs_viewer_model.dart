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

  List<String> formatLogLine(String line) {
    final el = line.split('  ');
    return [
      '${_stripBraces(el.last)} - ${_stripBraces(el.elementAt(3))}',
      '\n',
      '${_stripBraces(el.first)}::${_stripBraces(el.elementAt(1))}',
      '\n',
      (_stripBraces(el.elementAt(2))),
      '\n',
      '\n',
    ];
  }

  String _stripBraces(String word) {
    return word.substring(1, word.length - 1);
  }
}
