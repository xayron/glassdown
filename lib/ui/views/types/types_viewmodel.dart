import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/quick_settings/quick_settings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TypesViewModel extends BaseViewModel {
  final _scraper = locator<ScraperService>();
  final _token = CancelToken();
  final _nav = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();

  AppInfo? _app;
  AppInfo? get appTypes => _app;

  Future<void> showChangeFiltersModal() async {
    try {
      showQuickSettingsSheet();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: 'Failed to launch change filters bottom sheet',
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> fetchTypes(AppInfo app) async {
    try {
      setBusy(true);
      _app = await _scraper.getApkType(app, _token);
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  void cancel() {
    _token.cancel();
    _nav.previousRoute;
  }
}
