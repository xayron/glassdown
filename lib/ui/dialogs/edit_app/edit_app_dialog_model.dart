import 'package:stacked/stacked.dart';

class EditAppDialogModel extends FormViewModel {}

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
