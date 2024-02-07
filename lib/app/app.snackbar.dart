import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

enum SnackbarType { info, progress }

void setupSnackbarUi() {
  final snackbar = locator<SnackbarService>();

  snackbar.registerCustomSnackbarConfig(
    variant: SnackbarType.info,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      closeSnackbarOnMainButtonTapped: true,
      animationDuration: const Duration(milliseconds: 1000),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 15,
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true,
    ),
  );

  snackbar.registerCustomSnackbarConfig(
    variant: SnackbarType.progress,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      closeSnackbarOnMainButtonTapped: true,
      animationDuration: const Duration(milliseconds: 1000),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 15,
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true,
      showProgressIndicator: true,
    ),
  );

  snackbar.registerSnackbarConfig(
    SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      closeSnackbarOnMainButtonTapped: true,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
    ),
  );
}
