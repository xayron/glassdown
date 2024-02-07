import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'delete_logs_model.dart';

class DeleteLogs extends StackedView<DeleteLogsModel> {
  const DeleteLogs({super.key});

  @override
  Widget builder(
    BuildContext context,
    DeleteLogsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.deleteLogs(),
      child: const ItemWrapper(
        mainText: 'Delete logs',
        secondaryText: 'Load JSON with app list',
      ),
    );
  }

  @override
  DeleteLogsModel viewModelBuilder(
    BuildContext context,
  ) =>
      DeleteLogsModel();
}
