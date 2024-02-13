import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'apk_save_path_model.dart';

class ApkSavePath extends StackedView<ApkSavePathModel> {
  const ApkSavePath({super.key});

  @override
  Widget builder(
    BuildContext context,
    ApkSavePathModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.pickFolder(context),
      child: ItemWrapper(
        mainText: 'Change APK save path',
        secondaryText: 'Saved in: ${viewModel.exportApkPath}',
      ),
    );
  }

  @override
  ApkSavePathModel viewModelBuilder(
    BuildContext context,
  ) =>
      ApkSavePathModel();
}
