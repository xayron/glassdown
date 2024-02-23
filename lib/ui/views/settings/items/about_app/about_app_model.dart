import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AboutAppModel extends ReactiveViewModel {
  final _dialogService = locator<DialogService>();
  final _settings = locator<SettingsService>();
  final _snackbar = locator<SnackbarService>();

  bool get devOptions => _settings.devOptions;

  final loadingMsg = 'Loading...';
  AppPackageInfo? _info;
  AppPackageInfo? get info => _info;

  String get name => info?.appName ?? loadingMsg;
  String get version => info?.version ?? loadingMsg;
  String get buildNumber => info?.buildNumber ?? loadingMsg;

  void setDevOptions(bool val) => _settings.setDevOptions(val);

  String getDevOptionsSnackMessage() {
    if (devOptions) {
      return "You've enabled developer options. Please be careful with it!";
    } else {
      return 'Developer options disabled.';
    }
  }

  Future<void> getPackageInfo() async {
    _info = await _settings.getPackageInfo();
    rebuildUi();
  }

  Future<void> showAboutDialog() async {
    try {
      await _dialogService.showCustomDialog<void, void>(
        variant: DialogType.aboutApp,
        barrierDismissible: true,
      );
      rebuildUi();
    } catch (e) {
      _snackbar.showSnackbar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];
}
