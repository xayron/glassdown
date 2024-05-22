import 'dart:io';

import 'package:android_system_font/android_system_font.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/models/errors/io_error.dart';
import 'package:glass_down_v2/util/function_name.dart';
import 'package:path_provider/path_provider.dart';

typedef FontImport = ({int len, List<File> fontFiles});

class FontImporterService {
  FontLoader? _fontLoader;

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

      final fontName = pickedFontsArchive.name.split('.')[0];
      final fontsDir = Directory('${appDir.path}/fonts/$fontName');
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
        getFunctionName(),
        e.toString(),
      );
      rethrow;
    }
  }

  Future<ByteData> _readFileBytes(String path) async {
    var bytes = await File(path).readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  Future<bool> deleteFont(String fontName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      final fontsDir = Directory('${appDir.path}/fonts/$fontName');
      await fontsDir.delete(recursive: true);

      return true;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        e.toString(),
      );
      return false;
    }
  }

  Future<List<String>?> getFontList() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      final fontsDir = Directory('${appDir.path}/fonts');

      if (!fontsDir.existsSync()) {
        return null;
      }

      final fontDirList = fontsDir.listSync().whereType<Directory>().toList();
      final List<String> fontList = [];
      for (final fontDir in fontDirList) {
        fontList.add(_getFolderName(fontDir.path));
      }

      return fontList;
    } catch (e) {
      FlutterLogs.logError(
        runtimeType.toString(),
        getFunctionName(),
        "Couldn't load fonts from storage",
      );
      return null;
    }
  }

  String _getFolderName(String path) {
    return path.split('/').last;
  }

  Future<FontImport?> _getImportedFonts(String fontName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      final fontsDir = Directory('${appDir.path}/fonts/$fontName');

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

  Future<void> loadFonts(String fontName) async {
    try {
      if (fontName == 'System') {
        final systemFontPath = await AndroidSystemFont().getFilePath();
        if (systemFontPath == null) {
          return;
        }
        _fontLoader = FontLoader('CustomFont');
        _fontLoader!.addFont(_readFileBytes(systemFontPath));
        _fontLoader!.load();
        return;
      }
      final importedFonts = await _getImportedFonts(fontName);

      if (importedFonts == null || importedFonts.len == 0) {
        return;
      }

      _fontLoader = FontLoader('CustomFont');

      for (int i = 0; i < importedFonts.len; i++) {
        _fontLoader!
            .addFont(_prepareFont(importedFonts.fontFiles.elementAt(i)));
      }
      await _fontLoader!.load();
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
