import 'package:flutter/material.dart';
import 'package:glass_down_v2/services/custom_themes_service.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:glass_down_v2/util/casing.dart';
import 'package:stacked/stacked.dart';

import 'custom_theme_model.dart';

class CustomTheme extends StackedView<CustomThemeModel> {
  const CustomTheme({super.key});

  @override
  Widget builder(
    BuildContext context,
    CustomThemeModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: !viewModel.monetEnabled ? () => viewModel.handleTap() : null,
      child: ItemWrapper(
        mainText: 'Theme color',
        secondaryText: 'Pick color manually',
        enabled: !viewModel.monetEnabled,
        trailingWidget: MenuAnchor(
          controller: viewModel.controller,
          builder: (_, __, child) => child!,
          menuChildren: [
            for (final (i, theme) in MainColor.values.indexed)
              MenuItemButton(
                child: Text(
                  viewModel.menuName(theme.name.toCapitalized()),
                ),
                onPressed: () => viewModel.updateValue(theme, i),
              )
          ],
          child: FilledButton.tonal(
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll<Size>(
                Size(100, 0),
              ),
            ),
            onPressed:
                !viewModel.monetEnabled ? () => viewModel.handleTap() : null,
            child: Text(
              viewModel.customColor.name.toCapitalized(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  CustomThemeModel viewModelBuilder(
    BuildContext context,
  ) =>
      CustomThemeModel();
}
