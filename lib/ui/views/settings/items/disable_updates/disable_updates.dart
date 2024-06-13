import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'disable_updates_model.dart';

class DisableUpdates extends StackedView<DisableUpdatesModel> {
  const DisableUpdates({super.key});

  @override
  Widget builder(
    BuildContext context,
    DisableUpdatesModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () {
        viewModel.updateValue(!viewModel.disableUpdates);
      },
      child: ItemWrapper(
        mainText: 'Disable updates notification',
        secondaryText: 'Disable dialog notifying about new version',
        trailingWidget: Switch(
          onChanged: (value) {
            viewModel.updateValue(value);
          },
          value: viewModel.disableUpdates,
        ),
      ),
    );
  }

  @override
  DisableUpdatesModel viewModelBuilder(
    BuildContext context,
  ) =>
      DisableUpdatesModel();
}
