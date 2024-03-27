import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'exclude_bundles_model.dart';

class ExcludeBundles extends StackedView<ExcludeBundlesModel> {
  const ExcludeBundles({super.key, this.rounded = false});

  final bool rounded;

  @override
  Widget builder(
    BuildContext context,
    ExcludeBundlesModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      onTap: () {
        viewModel.updateValue(!viewModel.excludeBundles);
      },
      child: ItemWrapper(
        mainText: 'Exclude bundles',
        secondaryText: 'Skip bundled APKs',
        trailingWidget: Switch(
            onChanged: (value) {
              viewModel.updateValue(value);
            },
            value: viewModel.excludeBundles),
      ),
    );
  }

  @override
  ExcludeBundlesModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExcludeBundlesModel();
}
