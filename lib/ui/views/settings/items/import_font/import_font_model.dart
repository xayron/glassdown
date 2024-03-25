import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/services/font_importer_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ImportFontModel extends BaseViewModel {
  final _snackbar = locator<SnackbarService>();
  final _fontImporter = locator<FontImporterService>();

  final fontImportMessage =
      'Put the fonts you want to use into zip file. Name of the zip will be used as font name.';

  Future<void> showImportFontDialog() async {
    try {
      await _fontImporter.showImportFontDialog();
      _snackbar.showCustomSnackBar(
        message: 'Fonts imported',
        variant: SnackbarType.info,
      );
    } catch (e) {
      _snackbar.showCustomSnackBar(
        variant: SnackbarType.info,
        message: e.toString(),
      );
    }
  }
}
