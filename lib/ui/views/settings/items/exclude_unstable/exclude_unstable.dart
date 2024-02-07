import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'exclude_unstable_model.dart';

class ExcludeUnstable extends StackedView<ExcludeUnstableModel> {
  const ExcludeUnstable({super.key});

  @override
  Widget builder(
    BuildContext context,
    ExcludeUnstableModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () {
        viewModel.updateValue(!viewModel.excludeUnstable);
      },
      child: ItemWrapper(
        mainText: 'Exclude unstable',
        secondaryText: 'Skip alpha & beta versions',
        trailingWidget: Switch(
          onChanged: (value) {
            viewModel.updateValue(value);
          },
          value: viewModel.excludeUnstable,
        ),
      ),
    );
  }

  @override
  ExcludeUnstableModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExcludeUnstableModel();
}
