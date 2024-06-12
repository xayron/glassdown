import 'package:async/async.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/apps/apps_view.dart';
import 'package:open_filex/open_filex.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadStatusViewModel extends ReactiveViewModel {
  final _scraper = locator<ScraperService>();
  final _nav = locator<NavigationService>();
  final _token = CancelToken();
  final _snackbar = locator<SnackbarService>();
  final _dialog = locator<DialogService>();
  final _settings = locator<SettingsService>();

  CancelableOperation<bool>? operation;

  final revancedPackageName = 'app.revanced.manager.flutter';
  final saiPackageName = 'com.aefyr.sai';

  bool _canPop = false;
  bool get canPop {
    if (operation != null && operation!.isCompleted) {
      return true;
    }
    return _canPop;
  }

  Status get pageStatus => _scraper.pageStatus;
  Status get linkStatus => _scraper.linkStatus;
  Status get apkStatus => _scraper.apkStatus;
  double? get downloadProgress => _scraper.downloadProgress;
  Status get saveStatus => _scraper.saveStatus;
  bool get success => operation?.isCompleted ?? false;

  bool _revancedExists = false;
  bool get revancedExists => _revancedExists;

  bool _saiExists = false;
  bool get saiExists => _saiExists;

  bool _installStatus = false;
  bool get installStatus => _installStatus;

  Future<void> canInstallPackages() async {
    try {
      _installStatus = await _settings.installGranted();
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: "Cannot check install packages permission",
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> cancel() async {
    try {
      await operation?.cancel();
      _canPop = true;
    } catch (e) {
      setError(e);
    }
  }

  Future<void> returnTo({bool home = false}) async {
    if (home) {
      _nav.clearStackAndShowView(const AppsView());
    } else {
      _nav.previousRoute;
    }
    _scraper.clearStatuses();
  }

  Future<void> runDownload(AppInfo app) async {
    try {
      operation = CancelableOperation<bool>.fromFuture(
        _scraper.getSelectedApk(app, _token),
        onCancel: () {
          _token.cancel();
          showSnackbar('Download canceled');
        },
      );
    } catch (e) {
      setError(e);
    }
  }

  Future<void> openApk() async {
    try {
      final isBundle = saveStatus.$2!.split('.').last == 'apkm';
      if (isBundle) {
        if (_saiExists) {
          await DeviceApps.openApp(saiPackageName);
        } else {
          _dialog.showCustomDialog<void, void>(
            variant: DialogType.bundledApkInfo,
          );
        }
      } else {
        OpenFilex.open(saveStatus.$2);
      }
    } catch (e) {
      showSnackbar('Cannot open downloaded APK');
    }
  }

  Future<void> checkForRevancedApp() async {
    try {
      _revancedExists = await DeviceApps.isAppInstalled(revancedPackageName);
      rebuildUi();
    } catch (e) {
      showSnackbar('Cannot check if Revanced App exists on device');
    }
  }

  Future<void> checkForSai() async {
    try {
      _saiExists = await DeviceApps.isAppInstalled(saiPackageName);
      rebuildUi();
    } catch (e) {
      showSnackbar('Cannot check if Split APK Installer exists on device');
    }
  }

  Future<void> openRevanced() async {
    try {
      await DeviceApps.openApp(revancedPackageName);
    } catch (e) {
      showSnackbar('Cannot launch Revanced App');
    }
  }

  Future<void> openSai() async {
    try {
      await DeviceApps.openApp(saiPackageName);
    } catch (e) {
      showSnackbar('Cannot launch Revanced App');
    }
  }

  void showSnackbar(String msg) {
    _snackbar.showCustomSnackBar(
      variant: SnackbarType.info,
      message: msg,
    );
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_scraper];
}
