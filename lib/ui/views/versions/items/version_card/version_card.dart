import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:stacked/stacked.dart';

import 'version_card_model.dart';

class VersionCard extends StackedView<VersionCardModel> {
  const VersionCard({
    super.key,
    required this.app,
    required this.versionLink,
  });

  final VersionLink versionLink;
  final AppInfo app;

  @override
  Widget builder(
    BuildContext context,
    VersionCardModel viewModel,
    Widget? child,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        onTap: () {
          final selectedAppVersion = app.copyWith(pickedVersion: versionLink);
          viewModel.openTypesView(selectedAppVersion);
        },
        title: Text(versionLink.name),
        trailing: const Icon(
          Icons.keyboard_double_arrow_right,
        ),
      ),
    );
  }

  @override
  VersionCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      VersionCardModel();
}
