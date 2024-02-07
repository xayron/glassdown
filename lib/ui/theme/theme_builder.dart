import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.router.dart';
import 'package:glass_down_v2/ui/theme/theme_builder_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThemeBuilder extends StackedView<ThemeBuilderModel> {
  const ThemeBuilder({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        final monetPresent = lightDynamic != null && darkDynamic != null;

        if (monetPresent && viewModel.monetEnabled) {
          lightScheme = lightDynamic.harmonized();
          darkScheme = darkDynamic.harmonized();
        } else {
          lightScheme = viewModel.getTheme(viewModel.customTheme).lightScheme;
          darkScheme = viewModel.getTheme(viewModel.customTheme).darkScheme;
        }

        return MaterialApp(
          title: 'GlassDown',
          themeMode: viewModel.themeMode,
          theme: ThemeData(
            colorScheme: lightScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
          ),
          initialRoute: Routes.homeView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
        );
      },
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return ThemeBuilderModel();
  }
}
