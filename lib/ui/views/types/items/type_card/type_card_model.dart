import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/deleter_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/download_status/download_status_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TypeCardModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final _settings = locator<SettingsService>();
  final _snackbar = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  final _deleter = locator<DeleterService>();

  Future<void> openDownloadView(AppInfo app) async {
    if (!_settings.isConnected) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: 'You have no internet connection',
      );
      return;
    }
    if (!_settings.autoRemove && _settings.offerRemoval) {
      await showDialog(app);
    }
    _nav.navigateWithTransition(
      DownloadStatusView(app: app),
      preventDuplicates: false,
    );
  }

  Future<void> showDialog(AppInfo app) async {
    try {
      final response = await _dialogService.showCustomDialog<void, void>(
        variant: DialogType.deleteOldApks,
      );
      if (response != null && response.confirmed) {
        await _deleter.deleteOldVersions(app);
      }
    } catch (e) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: "Couldn't remove old versions",
      );
    }
  }
}
