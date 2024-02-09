import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class OfferDeletingOldApksModel extends BaseViewModel {
  bool get offerRemoval => _settings.offerRemoval;

  final _settings = locator<SettingsService>();

  void updateValue(bool value) {
    _settings.setOfferRemoval(value);
    rebuildUi();
  }
}
