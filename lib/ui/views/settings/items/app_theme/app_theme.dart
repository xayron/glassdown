import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:glass_down_v2/util/casing.dart';
import 'package:stacked/stacked.dart';

import 'app_theme_model.dart';

class AppTheme extends StackedView<AppThemeModel> {
  const AppTheme({super.key});

  @override
  Widget builder(
    BuildContext context,
    AppThemeModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.handleTap(),
      child: ItemWrapper(
        mainText: 'App theme',
        trailingWidget: MenuAnchor(
          controller: viewModel.controller,
          builder: (_, __, child) => child!,
          menuChildren: [
            for (final (i, theme) in ThemeMode.values.indexed)
              MenuItemButton(
                child: Text(
                  viewModel.menuName(theme.name.toCapitalized()),
                ),
                onPressed: () => viewModel.updateValue(theme, i),
              )
          ],
          child: FilledButton.tonal(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                const Size(100, 0),
              ),
            ),
            onPressed: () => viewModel.handleTap(),
            child: Text(
              viewModel.themeMode.name.toCapitalized(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  AppThemeModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppThemeModel();
}
