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
      onLongPress: () {
        viewModel.setDevOptions(!viewModel.devOptions);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(viewModel.getDevOptionsSnackMessage()),
          ),
        );
      },
      child: ItemWrapper(
        mainText: 'About',
        secondaryText: 'Version: ${viewModel.version}',
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
