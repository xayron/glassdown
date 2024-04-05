// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/about_app/about_app_dialog.dart';
import '../ui/dialogs/bundled_apk_info/bundled_apk_info_dialog.dart';
import '../ui/dialogs/delete_old_apks/delete_old_apks_dialog.dart';
import '../ui/dialogs/edit_app/edit_app_dialog.dart';

enum DialogType {
  editApp,
  aboutApp,
  deleteOldApks,
  bundledApkInfo,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.editApp: (context, request, completer) =>
        EditAppDialog(request: request, completer: completer),
    DialogType.aboutApp: (context, request, completer) =>
        AboutAppDialog(request: request, completer: completer),
    DialogType.deleteOldApks: (context, request, completer) =>
        DeleteOldApksDialog(request: request, completer: completer),
    DialogType.bundledApkInfo: (context, request, completer) =>
        BundledApkInfoDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
