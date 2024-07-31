import 'dart:io';

import 'package:dio/dio.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/services/paths_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:html/parser.dart' show parse;
import 'package:glass_down_v2/models/errors/scrape_error.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

typedef ApkTypeRecord = (String link, String arch);

typedef Status = (bool? status, String? message);

typedef StatusWithUri = (bool? status, String? message, Uri? uri);

typedef SearchResult = ({String imgLink, String name, String link});

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

  final badChars = RegExp(r'[ .:/+]+');

  Status _pageStatus = (null, null);
  Status _linkStatus = (null, null);
  Status _apkStatus = (null, null);
  double? _downloadProgress;
  StatusWithUri _saveStatus = (null, null, null);

  Status get pageStatus => _pageStatus;
  Status get linkStatus => _linkStatus;
  Status get apkStatus => _apkStatus;
  double? get downloadProgress => _downloadProgress;
  StatusWithUri get saveStatus => _saveStatus;

  void clearStatuses() {
    _pageStatus = (null, null);
    _linkStatus = (null, null);
    _apkStatus = (null, null);
    _downloadProgress = null;
    _saveStatus = (null, null, null);
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

  String _trimVersion(String currentName) {
    final names = currentName.split(' ');
    final List<String> version = [];
    for (final fragment in names.reversed) {
      version.add(fragment);
      if (fragment.startsWith(RegExp(r'^[0-9]'))) {
        break;
      }
    }
    return version.reversed.join(' ');
  }

  String _trimAppName(String currentName) {
    final names = currentName.split(' ');
    final List<String> version = [];
    for (final fragment in names) {
      if (!fragment.startsWith(RegExp(r'^[0-9]'))) {
        version.add(fragment);
      }
    }
    return version.join(' ');
  }

  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.apkmirror.com/',
      followRedirects: true,
      method: 'get',
      headers: {
        HttpHeaders.userAgentHeader:
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Edg/127.0.0.0',
      },
    ),
  );

  Future<List<SearchResult>> getAppSearch(String search) async {
    try {
      final response = await _dio.get<String>(
        '?post_type=app_release&searchtype=apk&s=$search',
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          'HTTP Error: Failed to fetch search list',
          response.statusMessage,
        );
      }

      final document = parse(response.data);
      final resultsWidget = document.getElementsByClassName('listWidget')[0];
      final allElements = resultsWidget.children.sublist(5);

      if (allElements[0].text.startsWith('No results')) {
        throw ScrapeError("No results found for '$search'");
      }

      final row = allElements.map((e) => e.getElementsByClassName('table-row'));
      final rowDeeper = row.map((e) => e.first);

      List<String> appNames = [];

      List<SearchResult> searchResults = [];
      for (final element in rowDeeper) {
        final logoElement = element.children[0].getElementsByTagName('img')[0];
        final textElement = element.children[1].getElementsByTagName('a')[0];
        final logoUrl = logoElement.attributes['src']?.replaceAll('32', '128');
        final name = _trimAppName(textElement.text);
        final link = textElement.attributes['href'];

        if (!appNames.contains(name) &&
            !name.contains('beta') &&
            !name.contains('alpha')) {
          searchResults.add((
            imgLink: 'https://www.apkmirror.com$logoUrl',
            name: name,
            link: link!,
          ));
        }
        appNames.add(name);
      }

      return searchResults;
    } catch (e) {
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      rethrow;
    }
  }

  VersionLink getLinkFromAppSearch(SearchResult searchResult) {
    try {
      final url = searchResult.link.split('/')[3];

      return (name: searchResult.name, url: url);
    } catch (e) {
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      rethrow;
    }
  }

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
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
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

      final isSinglePage =
          document.getElementsByClassName('pagination').isEmpty;

      if (page > 1 && isSinglePage) {
        return app.copyWith(links: []);
      }

      FlutterLogs.logThis(
        tag: runtimeType.toString(),
        subTag: getFunctionName(),
        level: apkList.isEmpty ? LogLevel.ERROR : LogLevel.INFO,
        logMessage: apkList.isEmpty
            ? 'No APK version list found'
            : 'Found ${apkList.length} versions',
      );

      List<VersionLink?> links;

      if (!_settings.excludeUnstable) {
        if (_settings.onlyUnstable) {
          links = apkList.map(
            (e) {
              final isUnstable =
                  e.outerHtml.contains('alpha') || e.outerHtml.contains('beta');
              if (isUnstable) {
                return (
                  name: _trimVersion(e.text),
                  url: e.attributes['href'] ?? '',
                );
              }
            },
          ).toList();
        } else {
          links = apkList.map(
            (e) {
              return (
                name: _trimVersion(e.text),
                url: e.attributes['href'] ?? '',
              );
            },
          ).toList();
        }
      } else {
        links = apkList.map(
          (e) {
            final isUnstable =
                e.outerHtml.contains('alpha') || e.outerHtml.contains('beta');
            if (!isUnstable) {
              return (
                name: _trimVersion(e.text),
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
      bool shouldFetchMore = false;
      int extraPages = 0;
      if (links.nonNulls.length < 15 && !isSinglePage && !innerFn) {
        shouldFetchMore = true;
        extraPages = 2;
      } else if (_settings.pagesAmount > 1 && !innerFn && !isSinglePage) {
        shouldFetchMore = true;
      } else {
        shouldFetchMore = false;
      }
      if (shouldFetchMore) {
        for (var i = 2; i < _settings.pagesAmount + 1 + extraPages; i++) {
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
      linksList.sort((a, b) {
        return _trimVersion(b.name).compareTo(_trimVersion(a.name));
      });

      return app.copyWith(links: linksList);
    } catch (e) {
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
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

      final downloads = parse(response.data).getElementById('downloads');
      final rows = downloads?.getElementsByClassName('table-row');
      final List<TypeInfo> typeList = [];

      final rewriteArchName = _settings.architecture.normalize();

      if (rows == null) {
        final TypeInfo singleType = (
          archDpi: 'any',
          isBundle: false,
          title: app.pickedVersion!.name,
          versionUrl: app.pickedVersion!.url,
        );
        return app.copyWith(types: [singleType]);
      }

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
          final arch = rowItems[1].text;
          final universalApk = arch != 'universal' && arch != 'noarch';
          if (!arch.contains(rewriteArchName) && universalApk) {
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
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      rethrow;
    }
  }

  Future<String> _getDownloadPage(
    String downloadPage,
    CancelToken token,
  ) async {
    try {
      final page1Response = await _dio.get<String>(
        downloadPage,
        cancelToken: token,
      );

      if (page1Response.statusCode != 200) {
        throw ScrapeError(
          "HTTP Error: can't get download button page",
          page1Response.statusMessage,
        );
      }

      final page2Link = parse(page1Response.data)
          .getElementsByClassName('accent_color')
          .where((e) =>
              e.attributes.containsKey('href') &&
              e.attributes['href']!.endsWith('download/'))
          .map((e) => e.attributes['href'])
          .toList()[0];

      if (page2Link == null) {
        throw ScrapeError(
          "HTTP Error: can't get download button page",
          page1Response.statusMessage,
        );
      }

      final response = await _dio.get<String>(
        page2Link,
        cancelToken: token,
      );

      if (response.statusCode != 200) {
        throw ScrapeError(
          "HTTP Error: can't get download button page",
          response.statusMessage,
        );
      }

      final parsedDlButtonPage = parse(response.data)
          .querySelectorAll('[rel="nofollow"]')
          .where((e) => e.attributes['href']!.contains('download'))
          .first
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
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
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
        getFunctionName(),
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
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      _linkStatus = (false, _getErrorMessage(e));
      _apkStatus = (false, _getErrorMessage(e));
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> _getApk(
    String apkLink,
    CancelToken token,
    String path,
  ) async {
    try {
      final apkFile = await _dio.download(
        apkLink,
        path,
        onReceiveProgress: (count, total) {
          _downloadProgress = count / total * 100;
          notifyListeners();
        },
        options: Options(
          responseType: ResponseType.bytes,
          headers: {HttpHeaders.acceptEncodingHeader: '*'},
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

      FlutterLogs.logInfo(
        runtimeType.toString(),
        getFunctionName(),
        'APK downloaded',
      );

      return true;
    } catch (e) {
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      _apkStatus = (false, _getErrorMessage(e));
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<String> _getSavePath(AppInfo app) async {
    try {
      final savePlace = await _paths.getFolderToSave();
      FlutterLogs.logInfo(
        runtimeType.toString(),
        getFunctionName(),
        'Found save path: ${savePlace.path}',
      );

      final appName = app.name.toLowerCase().replaceAll(
            badChars,
            '_',
          );
      String archName = app.pickedType!.archDpi.split(',')[0];
      archName = archName.replaceAll(' + ', '_');
      final versionName = app.pickedVersion?.name.replaceAll(badChars, '_');
      final name = '${appName}_${versionName}_$archName';

      final extension = app.pickedType!.isBundle ? 'apkm' : 'apk';

      final finalPath = '${savePlace.path}/$name.$extension';
      final exists = await File(finalPath).exists();

      File file;
      if (!exists) {
        file = File(finalPath);
      } else {
        final date = DateFormat('HH_mm_ss').format(DateTime.now());
        file = File('${savePlace.path}/${name}_$date.$extension');
      }
      FlutterLogs.logInfo(
        runtimeType.toString(),
        getFunctionName(),
        'Saving to: ${file.path}',
      );

      _saveStatus = (true, file.path, file.uri);

      return file.path;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is DioException ? e.message ?? e.error.toString() : e.toString(),
      );
      _saveStatus = (false, _getErrorMessage(e), null);
      _apkStatus = (false, _getErrorMessage(e));
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
      final savePath = await _getSavePath(app);
      await _getApk(downloadLink, token, savePath);

      FlutterLogs.logInfo(
        runtimeType.toString(),
        getFunctionName(),
        'File saved to disc',
      );

      return true;
    } catch (e) {
      String message = '';
      if (e is ScrapeError) {
        message = e.fullMessage();
      }

      if (e is DioException) {
        message = e.message ?? e.error.toString();
      }

      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        message,
      );
      if (_saveStatus.$1 == null) {
        _saveStatus = (false, _getErrorMessage(e), null);
      }
      _apkStatus = (false, _getErrorMessage(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
