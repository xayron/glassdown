import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/errors/app_error.dart';
import 'package:glass_down_v2/models/revanced/mapped_names.dart';
import 'package:glass_down_v2/models/revanced/revanced_app.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:stacked/stacked.dart';

class RevancedService with ListenableServiceMixin {
  RevancedService() {
    listenToReactiveValues([_apps]);
  }

  final _url = 'https://api.revanced.app/v2/patches/latest';
  final _dio = Dio(
    BaseOptions(method: 'get'),
  );

  final List<RevancedApp> _apps = [];
  List<RevancedApp> get allApps => _apps;
  List<RevancedApp> get supportedApps {
    return _apps.where((e) => e.mapperData != null).toList();
  }

  List<RevancedApp> get unsupportedApps {
    return _apps.where((e) => e.mapperData == null).toList();
  }

  bool _loadingPatches = false;
  bool get loadingPatches => _loadingPatches;

  RevancedApp? getRevancedApp(String url) {
    final result = _apps.where((e) => e.mapperData?.url == url).toList();
    return result.isEmpty ? null : result.first;
  }

  Future<void> getLatestPatches() async {
    try {
      _apps.clear();
      _loadingPatches = true;
      notifyListeners();
      final patches = await _dio.get<String>(_url);

      if (patches.statusCode != 200 || patches.data == null) {
        throw AppError('Revanced API Error', patches.statusMessage);
      }

      final parsedPatches = jsonDecode(patches.data!);

      final List<dynamic> packages = parsedPatches['patches']
          .map((el) => el['compatiblePackages'])
          .toList();

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

      _apps.sort((a, b) {
        if (a.mapperData?.fullName != null && b.mapperData?.fullName != null) {
          final first = a.mapperData!.fullName.toLowerCase();
          final second = b.mapperData!.fullName.toLowerCase();
          return first.compareTo(second);
        }
        return -1;
      });

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
