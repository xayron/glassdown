import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:glass_down_v2/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:glass_down_v2/services/scraper_service.dart';
import 'package:glass_down_v2/services/paths_service.dart';
import 'package:glass_down_v2/services/apps_service.dart';
import 'package:glass_down_v2/services/logs_service.dart';
import 'package:glass_down_v2/services/deleter_service.dart';
import 'package:glass_down_v2/services/updater_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ScraperService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PathsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AppsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<LogsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DeleterService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<UpdaterService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterScraperService();
  getAndRegisterPathsService();
  getAndRegisterAppsService();
  getAndRegisterLogsService();
  getAndRegisterDeleterService();
  getAndRegisterUpdaterService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockScraperService getAndRegisterScraperService() {
  _removeRegistrationIfExists<ScraperService>();
  final service = MockScraperService();
  locator.registerSingleton<ScraperService>(service);
  return service;
}

MockPathsService getAndRegisterPathsService() {
  _removeRegistrationIfExists<PathsService>();
  final service = MockPathsService();
  locator.registerSingleton<PathsService>(service);
  return service;
}

MockAppsService getAndRegisterAppsService() {
  _removeRegistrationIfExists<AppsService>();
  final service = MockAppsService();
  locator.registerSingleton<AppsService>(service);
  return service;
}

MockLogsService getAndRegisterLogsService() {
  _removeRegistrationIfExists<LogsService>();
  final service = MockLogsService();
  locator.registerSingleton<LogsService>(service);
  return service;
}

MockDeleterService getAndRegisterDeleterService() {
  _removeRegistrationIfExists<DeleterService>();
  final service = MockDeleterService();
  locator.registerSingleton<DeleterService>(service);
  return service;
}

MockUpdaterService getAndRegisterUpdaterService() {
  _removeRegistrationIfExists<UpdaterService>();
  final service = MockUpdaterService();
  locator.registerSingleton<UpdaterService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
