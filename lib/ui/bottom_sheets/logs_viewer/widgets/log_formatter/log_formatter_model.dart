import 'package:stacked/stacked.dart';

class LogFormatterModel extends BaseViewModel {
  List<String> formatLogLine(String line) {
    final el = line.split('  ');
    return [
      (_stripBraces(el.last)),
      '\n',
      _stripBraces(el.elementAt(3)),
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
