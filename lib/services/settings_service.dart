import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/services/custom_themes_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

typedef AppPackageInfo = ({String appName, String buildNumber, String version});

enum SettingsKey {
  monet,
  customTheme,
  themeMode,
  arch,
  excludeBundles,
  excludeUnstable,
  pagesAmount,
  autoRemove,
  offerRemoval,
  exportLogsPath,
  exportAppsPath,
  apkSavePath,
}

// ignore: constant_identifier_names
enum Architecture { arm64_v8a, armeabi_v7a, x86, any }

extension Replacer on Architecture {
  String normalize() {
    return name.replaceAll('_', '-');
  }
}

const defaultDirPath = '/storage/emulated/0/Download/GlassDown';

class SettingsService
    with ListenableServiceMixin
    implements InitializableDependency {
  SettingsService() {
    listenToReactiveValues([
      _themeMode,
      _customColor,
      _monetEnabled,
      _excludeBundles,
      _excludeUnstable,
      _architecture,
      _pagesAmount,
      _autoRemove,
      _offerRemoval,
      _exportLogsPath,
    ]);
  }

  late final SharedPreferences _prefs;

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  void setConnectionStatus(bool value) {
    _isConnected = value;
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _savePref<ThemeMode>(SettingsKey.themeMode, mode);
  }

  bool _supportMonet = true;
  bool get supportMonet => _supportMonet;
  bool _monetEnabled = true;
  bool get monetEnabled => _monetEnabled;
  void setMonetEnabled(bool value) {
    _monetEnabled = value;
    notifyListeners();
    _savePref<bool>(SettingsKey.monet, value);
  }

  MainColor _customColor = MainColor.blue;
  MainColor get customColor => _customColor;
  void setCustomColor(MainColor value) {
    _customColor = value;
    notifyListeners();
    _savePref<MainColor>(SettingsKey.customTheme, value);
  }

  bool _excludeBundles = true;
  bool get excludeBundles => _excludeBundles;
  void setExcludeBundles(bool value) {
    _excludeBundles = value;
    notifyListeners();
    _savePref<bool>(SettingsKey.excludeBundles, value);
  }

  bool _excludeUnstable = true;
  bool get excludeUnstable => _excludeUnstable;
  void setExcludeUnstable(bool value) {
    _excludeUnstable = value;
    notifyListeners();
    _savePref<bool>(SettingsKey.excludeUnstable, value);
  }

  Architecture _architecture = Architecture.arm64_v8a;
  Architecture get architecture => _architecture;
  void setArchitecture(Architecture value) {
    _architecture = value;
    notifyListeners();
    _savePref<Architecture>(SettingsKey.arch, value);
  }

  int _pagesAmount = 1;
  int get pagesAmount => _pagesAmount;
  void setPagesAmount(int value) {
    _pagesAmount = value;
    notifyListeners();
    _savePref<int>(SettingsKey.pagesAmount, value);
  }

  bool _autoRemove = false;
  bool get autoRemove => _autoRemove;
  void setAutoRemove(bool value) {
    _autoRemove = value;
    notifyListeners();
    _savePref<bool>(SettingsKey.autoRemove, value);
  }

  bool _offerRemoval = true;
  bool get offerRemoval => _offerRemoval;
  void setOfferRemoval(bool value) {
    _offerRemoval = value;
    notifyListeners();
    _savePref<bool>(SettingsKey.offerRemoval, value);
  }

  String _exportLogsPath = defaultDirPath;
  String get exportLogsPath => _exportLogsPath;
  void setExportLogsPath(String value) {
    _exportLogsPath = value;
    notifyListeners();
    _savePref<String>(SettingsKey.exportLogsPath, value);
  }

  String _exportAppsPath = defaultDirPath;
  String get exportAppsPath => _exportAppsPath;
  void setExportAppsPath(String value) {
    _exportAppsPath = value;
    notifyListeners();
    _savePref<String>(SettingsKey.exportAppsPath, value);
  }

  String _apkSavePath = defaultDirPath;
  String get apkSavePath => _apkSavePath;
  void setApkSavePath(String value) {
    _apkSavePath = value;
    notifyListeners();
    _savePref<String>(SettingsKey.apkSavePath, value);
  }

  bool _devOptions = false;
  bool get devOptions => _devOptions;
  void setDevOptions(bool val) {
    _devOptions = val;
  }

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final themeMode = _prefs.getString(SettingsKey.themeMode.name);
    _themeMode = themeMode != null
        ? ThemeMode.values.byName(themeMode)
        : ThemeMode.system;

    final customColor = _prefs.getString(SettingsKey.customTheme.name);
    _customColor = customColor != null
        ? MainColor.values.byName(customColor)
        : MainColor.blue;

    final supportMonet = await getSdkVersion();

    if (!supportMonet) {
      _monetEnabled = false;
      _supportMonet = false;
    } else {
      _monetEnabled = _prefs.getBool(SettingsKey.monet.name) ?? _monetEnabled;
    }

    _excludeBundles =
        _prefs.getBool(SettingsKey.excludeBundles.name) ?? _excludeBundles;
    _excludeUnstable =
        _prefs.getBool(SettingsKey.excludeUnstable.name) ?? _excludeUnstable;

    final arch = _prefs.getString(SettingsKey.arch.name);
    _architecture = arch != null
        ? Architecture.values.byName(arch)
        : Architecture.arm64_v8a;

    _pagesAmount = _prefs.getInt(SettingsKey.pagesAmount.name) ?? _pagesAmount;

    _autoRemove = _prefs.getBool(SettingsKey.autoRemove.name) ?? _autoRemove;
    _offerRemoval =
        _prefs.getBool(SettingsKey.offerRemoval.name) ?? _offerRemoval;
    _exportLogsPath =
        _prefs.getString(SettingsKey.exportLogsPath.name) ?? _exportLogsPath;
    _exportAppsPath =
        _prefs.getString(SettingsKey.exportAppsPath.name) ?? _exportAppsPath;
    _apkSavePath =
        _prefs.getString(SettingsKey.apkSavePath.name) ?? _apkSavePath;
  }

  Future<void> ensureAppDirExists() async {
    final defaultDir = Directory(defaultDirPath);
    final isDefaultDir = await defaultDir.exists();
    if (isDefaultDir) {
      await defaultDir.create();
    }
  }

  Future<void> _savePref<T extends Object>(SettingsKey key, T value) async {
    if (value is bool) {
      await _prefs.setBool(key.name, value);
    }
    if (value is String) {
      await _prefs.setString(key.name, value);
    }
    if (value is Enum) {
      await _prefs.setString(key.name, value.name);
    }
    if (value is int) {
      await _prefs.setInt(key.name, value);
    }
  }

  Future<AppPackageInfo> getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    return (
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }

  Future<bool> getSdkVersion() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt >= 31;
  }
}
