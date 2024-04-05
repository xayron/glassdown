import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'delete_old_versions_model.dart';

class DeleteOldVersions extends StackedView<DeleteOldVersionsModel> {
  const DeleteOldVersions({super.key, this.rounded = false});

  final bool rounded;

  @override
  Widget builder(
    BuildContext context,
    DeleteOldVersionsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      onTap: () {
        viewModel.updateValue(!viewModel.autoRemove);
      },
      child: ItemWrapper(
        mainText: 'Autoremove old versions',
        secondaryText: 'Always delete old versions without asking',
        trailingWidget: Switch(
          onChanged: (value) {
            viewModel.updateValue(value);
          },
          value: viewModel.autoRemove,
        ),
      ),
    );
  }

  @override
  DeleteOldVersionsModel viewModelBuilder(
    BuildContext context,
  ) =>
      DeleteOldVersionsModel();
}
