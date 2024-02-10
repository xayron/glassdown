import 'package:glass_down_v2/app/app.bottomsheets.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/ui/bottom_sheets/updater/updater_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheet() {
  final sheet = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.updater: (context, sheetReq, completer) =>
        UpdaterSheet(completer: completer, request: sheetReq)
  };

  sheet.setCustomSheetBuilders(builders);
}
