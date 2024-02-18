import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:stacked/stacked.dart';

import 'app_card_model.dart';

// ignore: must_be_immutable
class AppCard extends StackedView<AppCardModel> {
  AppCard({super.key, required this.app, required this.showEditDialog});

  AppInfo app;
  Future<void> Function(AppInfo) showEditDialog;

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
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            children: [Icon(Icons.edit)],
          ),
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.errorContainer,
        ),
        child: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.delete)],
          ),
        ),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          viewModel.dismissApp(app);
        }
        if (direction == DismissDirection.startToEnd) {
          showEditDialog(app);
        }
      },
      direction: DismissDirection.horizontal,
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
                  backgroundImage: CachedNetworkImageProvider(
                    app.imageUrl!,
                  ),
                )
              : null,
          title: Text(app.name),
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
