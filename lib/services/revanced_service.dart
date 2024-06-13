import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/errors/app_error.dart';
import 'package:glass_down_v2/models/revanced/mapped_names.dart';
import 'package:glass_down_v2/models/revanced/revanced_app.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';

class RevancedService with ListenableServiceMixin {
  RevancedService() {
    listenToReactiveValues([_apps]);
  }

  String _url =
      'https://api.github.com/repos/ReVanced/revanced-patches/releases/latest';
  final _dio = Dio(
    BaseOptions(method: 'get'),
  );
  final _settings = locator<SettingsService>();

  final List<RevancedApp> _apps = [];
  List<RevancedApp> get allApps => _apps;
  List<RevancedApp> get supportedApps {
    final apps = _apps.where((e) => e.mapperData != null).toList();
    apps.sort((a, b) {
      final first = a.mapperData!.fullName.toLowerCase();
      final second = b.mapperData!.fullName.toLowerCase();
      return first.compareTo(second);
    });
    return apps;
  }

  List<RevancedApp> get unsupportedApps {
    return _apps.where((e) => e.mapperData == null).toList();
  }

  bool _loadingPatches = false;
  bool get loadingPatches => _loadingPatches;

  void _getPatchesSource() {
    final source = _settings.patchesSource;
    switch (source) {
      case 'revanced':
        _url =
            'https://api.github.com/repos/ReVanced/revanced-patches/releases/latest';
        return;
      case 'revanced_extended':
        _url =
            'https://api.github.com/repos/inotia00/revanced-patches/releases/latest';
        return;
      default:
        _url =
            'https://api.github.com/repos/ReVanced/revanced-patches/releases/latest';
        return;
    }
  }

  RevancedApp? getRevancedApp(String url) {
    final result = _apps.where((e) => e.mapperData?.url == url).toList();
    return result.isEmpty ? null : result.first;
  }

  Future<void> getLatestPatches() async {
    try {
      _apps.clear();
      _loadingPatches = true;
      notifyListeners();
      _getPatchesSource();
      final ghPatches = await _dio.get<String>(_url);
      if (ghPatches.statusCode != 200 || ghPatches.data == null) {
        throw AppError('Revanced API Error', ghPatches.statusMessage);
      }

      final decodeGithub = jsonDecode(ghPatches.data!);
      final patchesUrl = decodeGithub['assets'][0]['browser_download_url'];

      if (patchesUrl is! String) {
        throw AppError('Revanced API Error', 'Cannot fetch link to patches');
      }

      final patches = await _dio.get(patchesUrl);
      if (patches.statusCode != 200 || patches.data == null) {
        throw AppError('Revanced API Error', patches.statusMessage);
      }

      final parsedPatches = jsonDecode(patches.data!);

      final List<dynamic> packages =
          parsedPatches.map((el) => el['compatiblePackages']).toList();

      for (final pkgList in packages) {
        if (pkgList == null) {
          continue;
        }

        for (final pkg in pkgList) {
          final name = pkg['name'];
          final versions = pkg['versions'];
          if (name is String && versions is List<dynamic>?) {
            final mappedName = RevancedMapper.getMappedAppName(name);
            final stringVersions = versions?.cast<String>();
            final appExists =
                _apps.where((e) => e.packageName == name).toList();
            if (appExists.isEmpty) {
              final app = RevancedApp(
                name,
                mappedName,
                stringVersions?.toSet(),
              );
              _apps.add(app);
            } else {
              appExists.first.addVersions(stringVersions);
            }
          }
        }
      }

      _loadingPatches = false;
      notifyListeners();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e is AppError ? e.fullMessage() : e.toString(),
      );
    }
  }
}
