import 'package:flutter/material.dart';
import 'package:glass_down_v2/services/settings_service.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'app_architecture_model.dart';

class AppArchitecture extends StackedView<AppArchitectureModel> {
  const AppArchitecture({super.key});

  @override
  Widget builder(
    BuildContext context,
    AppArchitectureModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.handleTap(),
      child: ItemWrapper(
        mainText: 'Architecture',
        secondaryText: 'Preferred CPU',
        trailingWidget: MenuAnchor(
          controller: viewModel.controller,
          builder: (_, __, child) => child!,
          menuChildren: [
            for (final (i, arch) in Architecture.values.indexed)
              MenuItemButton(
                child: Text(
                  viewModel.menuName(arch.name),
                ),
                onPressed: () => viewModel.updateValue(arch, i),
              )
          ],
          child: FilledButton.tonal(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                const Size(140, 0),
              ),
            ),
            onPressed: () => viewModel.handleTap(),
            child: Text(
              viewModel.architecture.name,
            ),
          ),
        ),
      ),
    );
  }

  @override
  AppArchitectureModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppArchitectureModel();
}
