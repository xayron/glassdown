import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/app_error.dart';
import 'package:glass_down_v2/models/revanced/revanced_app.dart';
import 'package:glass_down_v2/services/revanced_integration_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RevancedIntegrationViewModel extends ReactiveViewModel {
  final _revanced = locator<RevancedIntegrationService>();
  final _snackbar = locator<SnackbarService>();

  List<RevancedApp> get apps {
    return _revanced.apps.where((e) => e.mapperData != null).toList();
  }

  List<RevancedApp> get unsupportedApps {
    return _revanced.apps.where((e) => e.mapperData == null).toList();
  }

  bool get isLoading => _revanced.loadingPatches;
  bool _isAddingApp = false;
  bool get isAddingApp => _isAddingApp;

  void setIsAddingApp(bool value) {
    _isAddingApp = value;
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_revanced];

  Future<void> getLatestPatches() async {
    try {
      await _revanced.getLatestPatches();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is AppError ? e.fullMessage() : e.toString(),
        variant: SnackbarType.info,
      );
    }
  }
}
