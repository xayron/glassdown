import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'log_formatter_model.dart';

enum LogType { info, error }

class LogFormatter extends StackedView<LogFormatterModel> {
  const LogFormatter({super.key, required this.logs});

  final List<String> logs;

  TextSpan colorSpan(BuildContext context, int index, String text) {
    switch (index) {
      case 0:
        LogType logType = LogType.info;
        if (text.contains('INFO')) {
          logType = LogType.info;
        }
        if (text.contains('ERROR')) {
          logType = LogType.error;
        }
        return TextSpan(
          text: text,
          style: TextStyle(
            color: switch (logType) {
              LogType.info => Colors.green,
              LogType.error => Colors.red,
            },
            fontWeight: FontWeight.bold,
          ),
        );
      case 2:
        return TextSpan(
          text: text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        );
      case 4:
        return TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return TextSpan(text: text);
    }
  }

  @override
  Widget builder(
    BuildContext context,
    LogFormatterModel viewModel,
    Widget? child,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          for (final line in logs)
            TextSpan(
              children: [
                for (final (i, el) in viewModel.formatLogLine(line).indexed)
                  colorSpan(context, i, el)
              ],
            )
        ],
        style: GoogleFonts.jetBrainsMono(),
      ),
    );
  }

  @override
  LogFormatterModel viewModelBuilder(
    BuildContext context,
  ) =>
      LogFormatterModel();
}
