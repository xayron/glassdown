import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'show_permissions_model.dart';

class ShowPermissions extends StackedView<ShowPermissionsModel> {
  const ShowPermissions({super.key});

  @override
  Widget builder(
    BuildContext context,
    ShowPermissionsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.showPermissionsPage(),
      child: const ItemWrapper(
        mainText: 'Show permissions page',
      ),
    );
  }

  @override
  ShowPermissionsModel viewModelBuilder(
    BuildContext context,
  ) =>
      ShowPermissionsModel();
}
