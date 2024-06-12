import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'shizuku_installer_model.dart';

class ShizukuInstaller extends StackedView<ShizukuInstallerModel> {
  const ShizukuInstaller({
    super.key,
    this.rounded = false,
  });

  final bool rounded;

  @override
  Widget builder(
    BuildContext context,
    ShizukuInstallerModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      onTap: viewModel.shizukuAvailable()
          ? () => viewModel.updateValue(!viewModel.shizukuEnabled)
          : null,
      child: ItemWrapper(
        mainText: 'Shizuku installer (BETA)',
        secondaryText: 'Install APKs without interaction',
        trailingWidget: Switch(
          onChanged: viewModel.shizukuAvailable()
              ? (value) => viewModel.updateValue(value)
              : null,
          value: viewModel.shizukuEnabled,
        ),
      ),
    );
  }

  @override
  ShizukuInstallerModel viewModelBuilder(
    BuildContext context,
  ) =>
      ShizukuInstallerModel();
}
