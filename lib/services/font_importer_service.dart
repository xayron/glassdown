import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:path_provider/path_provider.dart';

typedef FontImport = ({int len, List<File> fontFiles});

class FontImporterService {
  final _fontLoader = FontLoader('CustomFont');

  Future<void> showImportFontDialog() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['zip'],
        dialogTitle: 'Pick zip file with fonts',
      );

      if (result == null) {
        throw IOError('No file picked');
      }

      final pickedFontsArchive = result.files.first;

      if (pickedFontsArchive.path == null) {
        throw IOError('No path for imported file exists');
      }

      final fontsZip = File(pickedFontsArchive.path!);

      final appDir = await getApplicationDocumentsDirectory();

      final fontsDir = Directory('${appDir.path}/fonts');
      if (!fontsDir.existsSync()) {
        await fontsDir.create(recursive: true);
      } else {
        await fontsDir.delete(recursive: true);
        await fontsDir.create(recursive: true);
      }

      await ZipFile.extractToDirectory(
        zipFile: fontsZip,
        destinationDir: fontsDir,
      );
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        'importAppList',
        e.toString(),
      );
      rethrow;
    }
  }

  Future<FontImport?> _getImportedFonts() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      final fontsDir = Directory('${appDir.path}/fonts');

      if (!fontsDir.existsSync()) {
        return null;
      }

      final fontFiles = fontsDir
          .listSync()
          .whereType<File>()
          .where((element) => element.path.split('.').last == 'ttf')
          .toList();

      return (fontFiles: fontFiles, len: fontFiles.length);
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        "Couldn't load fonts from storage",
      );
      rethrow;
    }
  }

  Future<ByteData> _prepareFont(File fontFile) async {
    try {
      final fontBytes = await fontFile.readAsBytes();
      return ByteData.sublistView(fontBytes);
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        "Couldn't load fonts from storage",
      );
      rethrow;
    }
  }

  Future<void> loadFonts() async {
    try {
      final importedFonts = await _getImportedFonts();

      if (importedFonts == null) {
        return;
      }

      for (int i = 0; i < importedFonts.len; i++) {
        _fontLoader.addFont(_prepareFont(importedFonts.fontFiles.elementAt(i)));
      }
      await _fontLoader.load();
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        "Couldn't load fonts from storage",
      );
      rethrow;
    }
  }
}
