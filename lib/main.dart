import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:glass_down_v2/app/app.dialogs.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:glass_down_v2/app/app.navigation.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/ui/theme/theme_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLogs.initLogs(
    logLevelsEnabled: [
      LogLevel.ERROR,
      LogLevel.WARNING,
      LogLevel.SEVERE,
      LogLevel.INFO
    ],
    directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE_2,
    logFileExtension: LogFileExtension.TXT,
  );
  await setupLocator();
  setupSnackbarUi();
  setupDialogUi();
  setupNavigationConfig();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    return const ThemeBuilder();
  }
}
