import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'check_updates_model.dart';

class CheckUpdates extends StackedView<CheckUpdatesModel> {
  const CheckUpdates({super.key});

  @override
  Widget builder(
    BuildContext context,
    CheckUpdatesModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.checkUpdates(),
      child: const ItemWrapper(
        mainText: 'Check for updates',
      ),
    );
  }

  @override
  CheckUpdatesModel viewModelBuilder(
    BuildContext context,
  ) =>
      CheckUpdatesModel();
}
