import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'export_logs_model.dart';

class ExportLogs extends StackedView<ExportLogsModel> {
  const ExportLogs({super.key});

  @override
  Widget builder(
    BuildContext context,
    ExportLogsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.exportLogs(),
      child: ItemWrapper(
        mainText: 'Export logs',
        secondaryText: 'Saved in: ${viewModel.exportLogsPath}',
        trailingWidget: FilledButton.tonal(
          onPressed: viewModel.storageStatus
              ? () => viewModel.pickFolder(context)
              : null,
          child: const Text('Change path'),
        ),
      ),
    );
  }

  @override
  ExportLogsModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExportLogsModel();
}
