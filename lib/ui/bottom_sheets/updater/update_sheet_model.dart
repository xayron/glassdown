import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/models/errors/update_error.dart';
import 'package:glass_down_v2/models/update_info.dart';
import 'package:glass_down_v2/services/updater_service.dart';
import 'package:stacked/stacked.dart';

enum PickedVersion { arm64, arm32 }

class UpdateSheetModel extends ReactiveViewModel {
  final _updater = locator<UpdaterService>();
  double get progress => _updater.downloadProgress;

  bool _started = false;
  bool get started => _started;

  UpdateInfo? updateInfo;
  PickedVersion pickedVersion = PickedVersion.arm64;

  void updateVersion(PickedVersion? value) {
    if (value != null) {
      pickedVersion = value;
      rebuildUi();
    }
  }

  Future<void> downloadUpdate() async {
    final version = pickedVersion == PickedVersion.arm64
        ? updateInfo!.arm64
        : updateInfo!.arm32;
    _started = true;
    notifyListeners();
    await _updater.downloadUpdate(version);
  }

  Future<void> checkUpdates() async {
    try {
      updateInfo = await _updater.getReleaseInfo();
      rebuildUi();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'checkUpdates',
        e is UpdateError ? e.message : e.toString(),
      );
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_updater];
}
