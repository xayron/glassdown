import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/errors/update_error.dart';
import 'package:glass_down_v2/models/update_info.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class UpdaterService with ListenableServiceMixin {
  UpdaterService() {
    listenToReactiveValues([_downloadProgress]);
  }

  final _url = 'https://api.github.com/repos/sinneida/glassdown/releases';
  final _dio = Dio(BaseOptions(method: 'get'));

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;
  dynamic updateData;
  bool _isDev = false;
  bool get isDev => _isDev;
  String _version = '';

  Future<void> downloadUpdate(AppReleaseInfo version) async {
    try {
      final app = await _dio.get<List<int>>(
        version.url!,
        onReceiveProgress: (count, total) {
          _downloadProgress = count / total * 100;
          notifyListeners();
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (app.statusCode != 200 || app.data == null) {
        throw UpdateError(
          'HTTP Error: failed to download the APK.',
          app.statusMessage,
        );
      }

      final dir = await getExternalStorageDirectory();

      if (dir == null) {
        throw UpdateError('Cannot get save directory path');
      }

      final file = File('${dir.path}/${version.name}.apk');

      final raf = file.openSync(mode: FileMode.writeOnly);

      raf.writeFromSync(app.data!);
      raf.closeSync();

      OpenFilex.open(file.path);
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is UpdateError ? e.fullMessage() : e.toString(),
      );
      _downloadProgress = 100;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  String _getUpdateUrl() {
    return _isDev ? _url : '$_url/latest';
  }

  Future<bool> checkUpdates() async {
    try {
      final package = await PackageInfo.fromPlatform();
      _isDev = package.version.contains('dev');
      _version = package.version;

      final result = await _dio.get<String>(_getUpdateUrl());

      if (result.statusCode != 200 || result.data == null) {
        throw UpdateError('Github API not available');
      }

      updateData = result.data;

      final updateStatus = await shouldUpdate();

      return updateStatus;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is UpdateError ? e.fullMessage() : 'Failed to check updates',
      );
      rethrow;
    }
  }

  Future<bool> shouldUpdate() async {
    final data = _isDev ? jsonDecode(updateData)[0] : jsonDecode(updateData);

    final String tagName = data['tag_name'];

    if (!_isDev) {
      final currentVersion =
          _version.contains('dev') ? _version.split('-')[0] : _version;
      final version = int.tryParse(currentVersion.split('.').join());
      final newVersion = int.tryParse(tagName.substring(1).split('.').join());

      if (version == null || newVersion == null) {
        throw UpdateError("Couldn't get version tags");
      }

      if (newVersion <= version) {
        return false;
      }
    }

    return true;
  }

  Future<UpdateInfo?> getReleaseInfo() async {
    try {
      final data = _isDev ? jsonDecode(updateData)[0] : jsonDecode(updateData);

      final String tagName = data['tag_name'];
      final changelog = data['body'];

      final List<dynamic> assets = data['assets'];

      final Map<String, dynamic> arm64 = assets[0];
      final Map<String, dynamic> arm32 = assets[1];

      final AppReleaseInfo arm64release = (
        name: arm64['name'],
        url: arm64['browser_download_url'],
      );
      final AppReleaseInfo arm32release = (
        name: arm32['name'],
        url: arm32['browser_download_url'],
      );

      return UpdateInfo(
        version: tagName,
        arm64: arm64release,
        arm32: arm32release,
        changelog: changelog,
      );
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        'Failed to fetch update info',
      );
      rethrow;
    }
  }
}
