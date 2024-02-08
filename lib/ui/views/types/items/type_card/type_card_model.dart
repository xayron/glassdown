import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/download_status/download_status_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TypeCardModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final _settings = locator<SettingsService>();
  final _snackbar = locator<SnackbarService>();

  void openDownloadView(AppInfo app) {
    if (!_settings.isConnected) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        title: 'Error',
        message: 'You have no internet connection',
      );
      return;
    }
    _nav.navigateWithTransition(
      DownloadStatusView(app: app),
      preventDuplicates: false,
    );
  }
}
