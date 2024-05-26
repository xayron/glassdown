import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/revanced_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/types/types_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VersionCardModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final _settings = locator<SettingsService>();
  final _snackbar = locator<SnackbarService>();
  final _revanced = locator<RevancedService>();

  final Set<String> _versions = {};
  Set<String> get versions => _versions;
  bool isRevancedSupported(String version) {
    if (_versions.contains('*')) {
      return true;
    }
    return _versions.contains(version);
  }

  void checkVersions(AppInfo app) {
    final result = _revanced.getRevancedApp(app.appUrl);
    if (result != null) {
      if (result.versions.isEmpty) {
        _versions.addAll(<String>{'*'});
      } else {
        _versions.addAll(result.versions);
      }
    }
    rebuildUi();
  }

  void openTypesView(AppInfo app) {
    if (!_settings.isConnected) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: 'You have no internet connection',
      );
      return;
    }
    _nav.navigateWithTransition(TypesView(app: app), preventDuplicates: false);
  }
}
