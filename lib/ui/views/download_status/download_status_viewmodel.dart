import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/ui/views/apps/apps_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadStatusViewModel extends ReactiveViewModel {
  final _scraper = locator<ScraperService>();
  final _nav = locator<NavigationService>();
  final _token = CancelToken();
  final _snackbar = locator<SnackbarService>();
  CancelableOperation<bool>? operation;

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

  void showSnackbar(String msg) {
    _snackbar.showCustomSnackBar(
      variant: SnackbarType.info,
      title: 'Warning',
      message: msg,
    );
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_scraper];
}
