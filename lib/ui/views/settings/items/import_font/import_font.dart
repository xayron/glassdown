import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'import_font_model.dart';

class ImportFont extends StackedView<ImportFontModel> {
  const ImportFont({super.key});

  @override
  Widget builder(
    BuildContext context,
    ImportFontModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.showImportFontDialog(),
      child: const ItemWrapper(
        mainText: 'Import font',
      ),
    );
  }

  @override
  ImportFontModel viewModelBuilder(
    BuildContext context,
  ) =>
      ImportFontModel();
}
