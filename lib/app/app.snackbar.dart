import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

enum SnackbarType { info, progress }

void setupSnackbarUi() {
  final snackbar = locator<SnackbarService>();

  snackbar.registerCustomSnackbarConfig(
    variant: SnackbarType.info,
    config: SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.info_outline_rounded),
      titleText: const Text('Info'),
      closeSnackbarOnMainButtonTapped: true,
      shouldIconPulse: false,
      snackStyle: SnackStyle.GROUNDED,
      dismissDirection: DismissDirection.down,
      isDismissible: true,
    ),
  );

  snackbar.registerCustomSnackbarConfig(
    variant: SnackbarType.progress,
    config: SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.info_outline_rounded),
      titleText: const Text('Info'),
      closeSnackbarOnMainButtonTapped: true,
      snackStyle: SnackStyle.GROUNDED,
      dismissDirection: DismissDirection.down,
      isDismissible: true,
      showProgressIndicator: true,
    ),
  );
}
