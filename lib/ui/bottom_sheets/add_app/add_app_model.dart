import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/models/errors/db_error.dart';
import 'package:glass_down_v2/models/errors/scrape_error.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddAppSheetModel extends FormViewModel {
  final _scraper = locator<ScraperService>();
  final _snackbar = locator<SnackbarService>();
  final _apps = locator<AppsService>();

  final List<SearchResult> _results = [];
  List<SearchResult> get results => _results;
  SearchResult? _appBeingAdded;
  SearchResult? get appBeingAdded => _appBeingAdded;

  bool _loading = false;
  bool get loading => _loading;

  bool _addingApp = false;
  bool get addingApp => _addingApp;

  final appNameController = TextEditingController();

  Future<void> addApp(SearchResult searchResult) async {
    try {
      _addingApp = true;
      _appBeingAdded = searchResult;
      rebuildUi();
      final app = await _scraper.getLinkFromAppSearch(searchResult);
      await _apps.addApp(app, searchResult.imgLink);
      _snackbar.showCustomSnackBar(
        message: 'App added succesfully',
        variant: SnackbarType.info,
      );
      rebuildUi();
      Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is DbError ? e.fullMessage() : e.toString(),
        variant: SnackbarType.info,
      );
      Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
    }
  }

  bool showProgress(SearchResult searchResult) {
    return searchResult == _appBeingAdded;
  }

  Future<void> searchApp(String search) async {
    try {
      _loading = true;
      rebuildUi();
      _results.clear();
      final searchResult = await _scraper.getAppSearch(search);
      _results.addAll(searchResult);
      _loading = false;
      rebuildUi();
    } catch (e) {
      _snackbar.showCustomSnackBar(
        message: e is ScrapeError
            ? e.message
            : e is DioException
                ? 'HTTP Error: ${e.type}'
                : e.toString(),
        variant: SnackbarType.info,
      );
      _loading = false;
      rebuildUi();
    }
  }
}
