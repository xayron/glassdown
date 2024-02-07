import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'import_apps_model.dart';

class ImportApps extends StackedView<ImportAppsModel> {
  const ImportApps({super.key});

  @override
  Widget builder(
    BuildContext context,
    ImportAppsModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.importApps(),
      child: const ItemWrapper(
        mainText: 'Import apps',
        secondaryText: 'Load JSON with app list',
      ),
    );
  }

  @override
  ImportAppsModel viewModelBuilder(
    BuildContext context,
  ) =>
      ImportAppsModel();
}
