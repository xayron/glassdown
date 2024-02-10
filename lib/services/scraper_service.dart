import 'dart:io';

import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/paths_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:html/parser.dart' show parse;
import 'package:glass_down_v2/models/errors/scrape_error.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:stacked/stacked.dart';

typedef ApkTypeRecord = (String link, String arch);

typedef Status = (bool? status, String? message);

class ScraperService with ListenableServiceMixin {
  ScraperService() {
    listenToReactiveValues([
      _pageStatus,
      _linkStatus,
      _apkStatus,
      _saveStatus,
    ]);
  }

  final _settings = locator<SettingsService>();
  final _paths = locator<PathsService>();

  Status _pageStatus = (null, null);
  Status _linkStatus = (null, null);
  Status _apkStatus = (null, null);
  double? _downloadProgress;
  Status _saveStatus = (null, null);

  Status get pageStatus => _pageStatus;
  Status get linkStatus => _linkStatus;
  Status get apkStatus => _apkStatus;
  double? get downloadProgress => _downloadProgress;
  Status get saveStatus => _saveStatus;

  void clearStatuses() {
    _pageStatus = (null, null);
    _linkStatus = (null, null);
    _apkStatus = (null, null);
    _downloadProgress = null;
    _saveStatus = (null, null);
  }

  String _getErrorMessage(dynamic e) {
    if (e is ScrapeError) {
      return e.fullMessage();
    } else if (e is DioException) {
      return e.message ?? 'HTTP Error';
    } else {
      return e.toString();
    }
  }

  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.apkmirror.com/',
      followRedirects: true,
      method: 'get',
    ),
  );

  Future<String?> getAppImage(VersionLink app) async {
    try {
      final response = await _dio.get<String>(
        'uploads/?appcategory=${app.url}',
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          'HTTP Error: Failed to fetch version list',
          response.statusMessage,
        );
      }

      final document = parse(response.data);
      final imgList = document
          .getElementsByClassName('widget_appmanager_recentpostswidget')[0]
          .getElementsByTagName('img');
      if (imgList.isEmpty) {
        return null;
      }

      final imageLink =
          imgList.first.attributes['src']?.replaceAll('32', '128');

      return imageLink != null ? 'https://www.apkmirror.com$imageLink' : null;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getAppImage',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      rethrow;
    }
  }

  Future<AppInfo> getVersionList(
    AppInfo app,
    CancelToken token, {
    int page = 1,
    bool innerFn = false,
  }) async {
    try {
      final url = page < 2
          ? 'uploads/?appcategory=${app.appUrl}'
          : 'uploads/page/$page/?appcategory=${app.appUrl}';
      final response = await _dio.get<String>(
        url,
        cancelToken: token,
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          'HTTP Error: Failed to fetch version list',
          response.statusMessage,
        );
      }

      final document = parse(response.data);
      final apkList = document
          .getElementsByClassName('widget_appmanager_recentpostswidget')[0]
          .getElementsByClassName('appRowTitle')
          .map((e) => e.children.first);

      FlutterLogs.logThis(
        tag: runtimeType.toString(),
        subTag: 'getVersionList',
        level: apkList.isEmpty ? LogLevel.ERROR : LogLevel.INFO,
        logMessage: apkList.isEmpty
            ? 'No APK version list found'
            : 'Found ${apkList.length} versions',
      );

      List<VersionLink?> links;

      if (!_settings.excludeUnstable) {
        links = apkList.map(
          (e) {
            return (
              name: e.text,
              url: e.attributes['href'] ?? '',
            );
          },
        ).toList();
      } else {
        links = apkList.map(
          (e) {
            final isUnstable =
                e.outerHtml.contains('alpha') || e.outerHtml.contains('beta');
            if (!isUnstable) {
              return (
                name: e.text,
                url: e.attributes['href'] ?? '',
              );
            }
          },
        ).toList();
      }

      if (links.isEmpty) {
        throw ScrapeError("There's no links to given APK");
      }

      final List<VersionLink> extraLinks = [];
      if (_settings.pagesAmount > 1 && !innerFn) {
        for (var i = 2; i < _settings.pagesAmount + 1; i++) {
          final result = await getVersionList(
            app,
            token,
            page: i,
            innerFn: true,
          );
          extraLinks.addAll(result.links);
        }
      }

      if (extraLinks.isNotEmpty) {
        links.addAll(extraLinks);
      }

      final linksList = links.nonNulls.toList();
      linksList.sort((a, b) => b.name.compareTo(a.name));

      return app.copyWith(links: linksList);
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getVersionList',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      rethrow;
    }
  }

  Future<AppInfo> getApkType(AppInfo app, CancelToken token) async {
    try {
      final response = await _dio.get<String>(
        app.pickedVersion!.url,
        cancelToken: token,
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          'HTTP Error: failed to fetch APK type picker page.',
          response.statusMessage ?? 'Unknown reason',
        );
      }

      final rows = parse(response.data)
          .getElementById('downloads')!
          .getElementsByClassName('table-row');
      final List<TypeInfo> typeList = [];

      final rewriteArchName = _settings.architecture.normalize();

      for (final row in rows) {
        final rowItems = row.children;
        if (rowItems.first.children.isEmpty) {
          continue;
        }

        final isBundle =
            rowItems.first.children[1].attributes['class']!.split(' ').length >
                1;
        if (_settings.excludeBundles && isBundle) {
          continue;
        }

        if (_settings.architecture != Architecture.any) {
          if (!rowItems[1].text.contains(rewriteArchName) &&
              rowItems[1].text != 'universal') {
            continue;
          }
        }

        typeList.add(
          (
            title: app.pickedVersion!.name,
            archDpi: '${rowItems[1].text}, ${rowItems[3].text}',
            isBundle: isBundle,
            versionUrl: rowItems[4].children.first.attributes['href']!,
          ),
        );
      }

      return app.copyWith(types: typeList);
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getApkType',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      rethrow;
    }
  }

  Future<String> _getDownloadPage(
    String downloadPage,
    CancelToken token,
  ) async {
    try {
      final response = await _dio.get<String>(
        downloadPage,
        cancelToken: token,
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          "HTTP Error: can't get download button page",
          response.statusMessage,
        );
      }

      final parsedDlButtonPage = parse(response.data)
          .getElementsByClassName('downloadButton')[0]
          .attributes['href'];

      if (parsedDlButtonPage == null) {
        throw ScrapeError(
          "Can't get download link",
          response.statusMessage,
        );
      }

      _pageStatus = (true, null);

      return parsedDlButtonPage;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getDownloadPage',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      _pageStatus = (false, _getErrorMessage(e));
      _linkStatus = (false, _getErrorMessage(e));
      _apkStatus = (false, _getErrorMessage(e));
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<String> _getDownloadLink(
      String downloadLink, CancelToken token) async {
    try {
      final response = await _dio.get<String>(downloadLink, cancelToken: token);

      if (response.statusCode != 200) {
        throw ScrapeError(
          "Can't get download link",
          response.statusMessage,
        );
      }

      final lastPageParsed = parse(response.data)
          .getElementsByTagName('a')
          .firstWhere((element) => element.text == 'here')
          .attributes['href'];

      FlutterLogs.logInfo(
        runtimeType.toString(),
        '_getDownloadLink',
        'Parsed final page',
      );

      if (lastPageParsed == null) {
        throw ScrapeError(
          "Can't find download link",
          response.statusMessage,
        );
      }

      _linkStatus = (true, null);

      return lastPageParsed;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getDownloadLink',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      _linkStatus = (false, _getErrorMessage(e));
      _apkStatus = (false, _getErrorMessage(e));
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<List<int>?> _getApk(String apkLink, CancelToken token) async {
    try {
      final apkFile = await _dio.get<List<int>>(
        apkLink,
        onReceiveProgress: (count, total) {
          _downloadProgress = count / total * 100;
          notifyListeners();
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
        cancelToken: token,
      );

      if (apkFile.statusCode != 200) {
        throw ScrapeError(
          'HTTP Error: failed to download the APK.',
          apkFile.statusMessage,
        );
      }

      _apkStatus = (true, null);

      return apkFile.data;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getAppImage',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      _apkStatus = (false, _getErrorMessage(e));
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> getSelectedApk(AppInfo app, CancelToken token) async {
    try {
      final linkToDownloadPage = app.pickedType!.versionUrl;
      final downloadPage = await _getDownloadPage(linkToDownloadPage, token);
      final downloadLink = await _getDownloadLink(downloadPage, token);
      final apk = await _getApk(downloadLink, token);
      FlutterLogs.logInfo(
        runtimeType.toString(),
        'getSelectedApk',
        'APK downloaded',
      );

      final savePlace = await _paths.getFolderToSave();
      FlutterLogs.logInfo(
        runtimeType.toString(),
        'getSelectedApk',
        'Found save path: ${savePlace.path}',
      );

      final name =
          '${app.pickedVersion?.name.replaceAll(RegExp(r'[ :]+'), '_') ?? app.name}_${_settings.architecture.normalize()}';
      final file = File(
        '${savePlace.path}/$name.apk',
      );
      FlutterLogs.logInfo(
        runtimeType.toString(),
        'getSelectedApk',
        'Saving to: ${file.path}',
      );

      final raf = file.openSync(mode: FileMode.writeOnly);

      FlutterLogs.logInfo(
        runtimeType.toString(),
        'getSelectedApk',
        'Opened file for writing...',
      );

      raf.writeFromSync(apk!);
      raf.closeSync();

      FlutterLogs.logInfo(
        runtimeType.toString(),
        'getSelectedApk',
        'File saved to disc',
      );

      _saveStatus = (true, null);
      return true;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'getSelectedApk',
        e is ScrapeError ? e.fullMessage() : e.toString(),
      );
      _saveStatus = (false, _getErrorMessage(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
