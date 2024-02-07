import 'package:glass_down_v2/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

void setupNavigationConfig() {
  final navigator = locator<NavigationService>();

  navigator.config(
    defaultTransitionStyle: Transition.rightToLeft,
  );
}
