import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'about_app_model.dart';

class AboutApp extends StackedView<AboutAppModel> {
  const AboutApp({super.key});

  @override
  Widget builder(
    BuildContext context,
    AboutAppModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.showAboutDialog(),
      child: ItemWrapper(
        mainText: viewModel.name,
        secondaryText:
            'Version: ${viewModel.version}\nBuild number: ${viewModel.buildNumber}',
        threeLined: true,
      ),
    );
  }

  @override
  AboutAppModel viewModelBuilder(
    BuildContext context,
  ) =>
      AboutAppModel();

  @override
  void onViewModelReady(AboutAppModel viewModel) {
    viewModel.getPackageInfo();
    super.onViewModelReady(viewModel);
  }
}
