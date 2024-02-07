import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadStatusViewModel extends ReactiveViewModel {
  final _scraper = locator<ScraperService>();
  final _nav = locator<NavigationService>();
  final _token = CancelToken();
  final _snackbar = locator<SnackbarService>();
  CancelableOperation<void>? operation;

  bool _canPop = false;
  bool get canPop => _canPop;

  Status get pageStatus => _scraper.pageStatus;
  Status get linkStatus => _scraper.linkStatus;
  Status get apkStatus => _scraper.apkStatus;
  double? get downloadProgress => _scraper.downloadProgress;
  Status get saveStatus => _scraper.saveStatus;

  Future<void> cancel() async {
    try {
      _token.cancel();
      await operation?.cancel();
      _canPop = true;
      // rebuildUi();
    } catch (e) {
      setError(e);
    }
  }

  Future<void> returnTo({bool home = false}) async {
    if (home) {
      _nav.clearStackAndShowView(const HomeView());
    } else {
      _nav.back();
    }
    _scraper.clearStatuses();
  }

  void runDownload(AppInfo app) {
    try {
      operation = CancelableOperation.fromFuture(
        _scraper.getSelectedApk(app, _token),
        onCancel: () {
          showSnackbar('Download canceled');
        },
      );
    } catch (e) {
      setError(e);
    }
  }

  void showSnackbar(String msg) {
    _snackbar.showSnackbar(message: msg);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_scraper];
}
