import 'package:flutter/material.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/ui/views/apps/items/app_card/app_card.dart';
import 'package:stacked/stacked.dart';

import 'apps_viewmodel.dart';

class AppsView extends StackedView<AppsViewModel> {
  const AppsView({super.key});
  @override
  Widget builder(
    BuildContext context,
    AppsViewModel viewModel,
    Widget? child,
  ) {
    final snackColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    setupSnackbarUi(snackColor, textColor);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          viewModel.showAddDialog();
        },
        label: const Text('Add app'),
        icon: const Icon(Icons.add),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () => viewModel.showSettings(),
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
            ),
            // IconButton(
            //   onPressed: () => viewModel.showRevancedIntegration(),
            //   icon: const Icon(Icons.workspaces_filled),
            //   tooltip: 'Revanced Integration',
            // ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 90,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
              title: Text(
                'Apps',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          if (viewModel.loading)
            const SliverToBoxAdapter(
              child: LinearProgressIndicator(),
            ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final app in viewModel.apps)
                    AppCard(
                      app: app,
                      showEditDialog: viewModel.showEditDialog,
                    ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  AppsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppsViewModel();

  @override
  void onViewModelReady(AppsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.checkPermissions();
    viewModel.allApps();
    viewModel.checkUpdates();
  }
}
