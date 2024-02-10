import 'dart:async';

import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends StreamViewModel with IndexTrackingStateHelper {
  final _settings = locator<SettingsService>();

  Future<void> handlePermissions() async {
    await Permission.manageExternalStorage
        .onPermanentlyDeniedCallback(() => openAppSettings())
        .onDeniedCallback(() => openAppSettings())
        .request();
    await Permission.requestInstallPackages
        .onPermanentlyDeniedCallback(() => openAppSettings())
        .onDeniedCallback(() => openAppSettings())
        .request();
  }

  @override
  void onData(data) {
    super.onData(data);
    if (data != null && data is InternetStatus) {
      switch (data) {
        case InternetStatus.connected:
          _settings.setConnectionStatus(true);
        case InternetStatus.disconnected:
          _settings.setConnectionStatus(false);
      }
    }
  }

  @override
  Stream<InternetStatus> get stream => InternetConnection().onStatusChange;
}
