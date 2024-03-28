import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/models/revanced/revanced_app.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RevancedAppCardModel extends BaseViewModel {
  final _snackbar = locator<SnackbarService>();
  final _apps = locator<AppsService>();

  bool _isAdding = false;
  bool get isAdding => _isAdding;

  bool _alreadyExists = false;
  bool get alreadyExists => _alreadyExists;

  void isAdded(RevancedApp app) {
    if (app.mapperData != null) {
      _alreadyExists = _apps.checkIfAppExists(app.mapperData!.url);
    } else {
      _alreadyExists = false;
    }
    rebuildUi();
  }

  Future<void> addApp(RevancedApp app, void Function(bool) setAddingApp) async {
    try {
      setAddingApp(true);
      _isAdding = true;
      rebuildUi();
      await _apps.addApp(
        (name: app.mapperData!.fullName, url: app.mapperData!.url),
      );
      setAddingApp(false);
      _isAdding = false;
      rebuildUi();
      _snackbar.showCustomSnackBar(
        message: 'App added succesfully',
        variant: SnackbarType.info,
      );
      isAdded(app);
    } catch (e) {
      setAddingApp(false);
      _isAdding = false;
      rebuildUi();
      _snackbar.showCustomSnackBar(
        message: e is DbError
            ? e.fullMessage()
            : e is DioException
                ? 'HTTP Error: ${e.type}'
                : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
