import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'monet_theme_model.dart';

class MonetTheme extends StackedView<MonetThemeModel> {
  const MonetTheme({super.key});

  @override
  Widget builder(
    BuildContext context,
    MonetThemeModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: viewModel.supportMonet
          ? () => viewModel.updateValue(!viewModel.monetEnabled)
          : null,
      child: ItemWrapper(
        enabled: viewModel.supportMonet,
        mainText: 'Material You',
        secondaryText: 'Get colors from your system',
        trailingWidget: Switch(
          onChanged: viewModel.supportMonet
              ? (value) => viewModel.updateValue(value)
              : null,
          value: viewModel.monetEnabled,
        ),
      ),
    );
  }

  @override
  MonetThemeModel viewModelBuilder(
    BuildContext context,
  ) =>
      MonetThemeModel();
}
