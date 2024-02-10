// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/about_app/about_app_dialog.dart';
import '../ui/dialogs/add_app/add_app_dialog.dart';
import '../ui/dialogs/delete_old_apks/delete_old_apks_dialog.dart';

enum DialogType {
  addApp,
  aboutApp,
  deleteOldApks,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.addApp: (context, request, completer) =>
        AddAppDialog(request: request, completer: completer),
    DialogType.aboutApp: (context, request, completer) =>
        AboutAppDialog(request: request, completer: completer),
    DialogType.deleteOldApks: (context, request, completer) =>
        DeleteOldApksDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
