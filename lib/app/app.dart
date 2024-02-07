import 'package:glass_down_v2/services/local_db_service.dart';
import 'package:glass_down_v2/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:glass_down_v2/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:glass_down_v2/services/custom_themes_service.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/views/versions/versions_view.dart';
import 'package:glass_down_v2/ui/dialogs/add_app/add_app_dialog.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/services/paths_service.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:glass_down_v2/ui/views/types/types_view.dart';
import 'package:glass_down_v2/ui/views/download_status/download_status_view.dart';
import 'package:glass_down_v2/ui/dialogs/about_app/about_app_dialog.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: VersionsView),
    MaterialRoute(page: TypesView),
    MaterialRoute(page: DownloadStatusView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: CustomThemesService),
    InitializableSingleton(classType: LocalDbService),
    InitializableSingleton(classType: SettingsService),
    LazySingleton(classType: ScraperService),
    LazySingleton(classType: PathsService),
    LazySingleton(classType: AppsService),
    LazySingleton(classType: LogsService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: AddAppDialog),
    StackedDialog(classType: AboutAppDialog),
// @stacked-dialog
  ],
)
class App {}