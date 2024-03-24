import 'package:stacked/stacked.dart';

class EditAppDialogModel extends FormViewModel {
  final message =
      'App url field should contain the appcategory part of URL, like:\n';
  final urlMessage = 'https://www.apkmirror.com/uploads/?appcategory=';
  final appMessage = 'messenger';
}

class EditAppDialogValidators {
  static String? validateAppName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter app name';
    }
    return null;
  }

  static String? validateAppUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter app url';
    }
    return null;
  }
}
