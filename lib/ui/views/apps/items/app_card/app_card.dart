import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:stacked/stacked.dart';

import 'app_card_model.dart';

// ignore: must_be_immutable
class AppCard extends StackedView<AppCardModel> {
  AppCard({super.key, required this.app});

  AppInfo app;

  @override
  Widget builder(
    BuildContext context,
    AppCardModel viewModel,
    Widget? child,
  ) {
    return Dismissible(
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.errorContainer,
        ),
      ),
      onDismissed: (_) {
        viewModel.dismissApp(app);
      },
      key: UniqueKey(),
      child: Card(
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        child: ListTile(
          onTap: () {
            viewModel.openVersionsView(app);
          },
          leading: app.imageUrl != null
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage: Image.network(app.imageUrl!).image,
                )
              : null,
          title: Text(app.name),
          // subtitle: const Text('Suggested version: ?'),
          // trailing: const Icon(Icons.keyboard_double_arrow_right),
        ),
      ),
    );
  }

  @override
  AppCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppCardModel();
}
