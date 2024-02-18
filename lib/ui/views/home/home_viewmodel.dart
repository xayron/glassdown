import 'dart:async';

import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/permissions/permissions_view.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends StreamViewModel with IndexTrackingStateHelper {
  final _settings = locator<SettingsService>();
  final _nav = locator<NavigationService>();

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

  Future<void> init() async {
    final storageGranted =
        await Permission.manageExternalStorage.status.isGranted;
    final installGranted =
        await Permission.requestInstallPackages.status.isGranted;
    if (!storageGranted || !installGranted) {
      _nav.replaceWithTransition(const PermissionsView());
    }
  }

  @override
  Stream<InternetStatus> get stream => InternetConnection().onStatusChange;
}
