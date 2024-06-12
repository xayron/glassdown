import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/ui/views/permissions/permissions_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShowPermissionsModel extends BaseViewModel {
  final _navigation = locator<NavigationService>();

  void showPermissionsPage() {
    _navigation.navigateWithTransition(const PermissionsView());
  }
}
