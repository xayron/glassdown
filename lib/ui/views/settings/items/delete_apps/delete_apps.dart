import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'delete_apps_model.dart';

class DeleteApps extends StackedView<DeleteAppsModel> {
  const DeleteApps({super.key});

  @override
  Widget builder(
    BuildContext context,
    DeleteAppsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () {
        viewModel.deleteApps();
      },
      child: const ItemWrapper(
        mainText: 'Delete all apps',
      ),
    );
  }

  @override
  DeleteAppsModel viewModelBuilder(
    BuildContext context,
  ) =>
      DeleteAppsModel();
}
