import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/revanced/revanced_app.dart';
import 'package:glass_down_v2/ui/views/revanced_integration/items/revanced_app_card_model.dart';
import 'package:stacked/stacked.dart';

class RevancedAppCard extends StackedView<RevancedAppCardModel> {
  const RevancedAppCard({
    super.key,
    required this.app,
    required this.setAddingApp,
    required this.isEnabled,
  });

  final RevancedApp app;
  final void Function(bool) setAddingApp;
  final bool isEnabled;

  @override
  Widget builder(
    BuildContext context,
    RevancedAppCardModel viewModel,
    Widget? child,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      child: app.mapperData == null
          ? ListTile(enabled: false, title: Text(app.packageName))
          : ListTile(
              onTap: () => viewModel.addApp(app, setAddingApp),
              enabled: viewModel.alreadyExists
                  ? false
                  : viewModel.isAdding
                      ? false
                      : true,
              subtitle: Text(app.packageName),
              title: Text(app.mapperData?.fullName ?? 'No name'),
              trailing: viewModel.alreadyExists
                  ? const Icon(
                      Icons.check,
                      color: Colors.lightGreen,
                    )
                  : viewModel.isAdding
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.add),
            ),
    );
  }

  @override
  RevancedAppCardModel viewModelBuilder(BuildContext context) =>
      RevancedAppCardModel();

  @override
  void onViewModelReady(RevancedAppCardModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.isAdded(app);
  }
}
