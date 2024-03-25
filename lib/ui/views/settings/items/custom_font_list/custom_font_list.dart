import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'custom_font_list_model.dart';

class CustomFontList extends StackedView<CustomFontListModel> {
  const CustomFontList({super.key});

  @override
  Widget builder(
    BuildContext context,
    CustomFontListModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.showCustomFonts(),
      child: const ItemWrapper(
        mainText: 'Select font',
      ),
    );
  }

  @override
  CustomFontListModel viewModelBuilder(
    BuildContext context,
  ) =>
      CustomFontListModel();
}
