import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'use_custom_font_model.dart';

class UseCustomFont extends StackedView<UseCustomFontModel> {
  const UseCustomFont({super.key});

  @override
  Widget builder(
    BuildContext context,
    UseCustomFontModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () {
        viewModel.updateValue(!viewModel.useImportedFont);
      },
      child: ItemWrapper(
        mainText: 'Use imported font',
        secondaryText: 'Fallbacks to Roboto',
        trailingWidget: Switch(
          onChanged: (value) => viewModel.updateValue(value),
          value: viewModel.useImportedFont,
        ),
      ),
    );
  }

  @override
  UseCustomFontModel viewModelBuilder(
    BuildContext context,
  ) =>
      UseCustomFontModel();
}
