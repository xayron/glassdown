import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/quick_settings/quick_settings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

const versionErrKey = 'version-err';

class VersionsViewModel extends ReactiveViewModel {
  final _scraper = locator<ScraperService>();
  final _token = CancelToken();
  final _nav = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();
  final _settings = locator<SettingsService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_settings];

  AppInfo? _app;
  AppInfo? get appWithLinks => _app;

  int _pageCount = 0;
  int get pageCount => _pageCount;

  int get settingsPages => _settings.pagesAmount;

  late final myScroller = ScrollController()..addListener(onScroll);

  Future<void> showQuickSettingsModal() async {
    try {
      showQuickSettingsSheet();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: 'Failed to launch quick settings bottom sheet',
        variant: SnackbarType.info,
      );
    }
  }

  Future<void> loadMore(AppInfo app) async {
    try {
      setBusy(true);
      final moreLinks = await _scraper.getVersionList(
        app,
        _token,
        page: _pageCount + settingsPages + 1,
        innerFn: true,
      );
      if (moreLinks.links.isEmpty) {
        return;
      }
      _app?.links.addAll(moreLinks.links);
      _pageCount++;
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> onScroll() async {
    final maxScroll = myScroller.position.maxScrollExtent;
    final currentScroll = myScroller.position.pixels;
    if (maxScroll - currentScroll == 0) {
      if (_app != null) {
        await loadMore(_app!);
      }
    }
  }

  Future<void> fetchVersions(AppInfo app) async {
    try {
      _pageCount = 0;
      setBusy(true);
      _app = await _scraper.getVersionList(app, _token);
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
