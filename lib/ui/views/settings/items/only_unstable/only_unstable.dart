import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'only_unstable_model.dart';

class OnlyUnstable extends StackedView<OnlyUnstableModel> {
  const OnlyUnstable({super.key, this.rounded = false});

  final bool rounded;

  @override
  Widget builder(
    BuildContext context,
    OnlyUnstableModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      onTap: viewModel.excludeUnstable
          ? null
          : () {
              viewModel.updateValue(!viewModel.onlyUnstable);
            },
      child: ItemWrapper(
        mainText: 'Unstable only',
        secondaryText: 'Show only alpha & beta versions',
        trailingWidget: Switch(
          onChanged: viewModel.excludeUnstable
              ? null
              : (value) {
                  viewModel.updateValue(value);
                },
          value: viewModel.onlyUnstable,
        ),
      ),
    );
  }

  @override
  OnlyUnstableModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnlyUnstableModel();
}
