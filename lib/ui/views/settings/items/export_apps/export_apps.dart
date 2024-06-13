import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'export_apps_model.dart';

class ExportApps extends StackedView<ExportAppsModel> {
  const ExportApps({super.key});

  @override
  Widget builder(
    BuildContext context,
    ExportAppsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.exportApps(),
      child: ItemWrapper(
        mainText: 'Export apps',
        secondaryText: 'Saved in: ${viewModel.exportAppsPath}',
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
  ExportAppsModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExportAppsModel();

  @override
  void onViewModelReady(ExportAppsModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getStoragePermissionStatus();
  }
}
