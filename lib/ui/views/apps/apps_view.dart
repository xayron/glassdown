import 'package:flutter/material.dart';
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          viewModel.showAddDialog();
        },
        label: const Text('Add app'),
        icon: const Icon(Icons.add),
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
          if (viewModel.showBanner)
            SliverToBoxAdapter(
              child: MaterialBanner(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                content: const Text(
                    'This release introduces new database. If you have a backup of your apps, please reexport them as previous format won\'t work.'),
                leading: const Icon(Icons.warning),
                backgroundColor:
                    Theme.of(context).colorScheme.errorContainer.withAlpha(120),
                actions: [
                  TextButton(
                    onPressed: () => viewModel.closeBanner(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
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
    viewModel.allApps();
    viewModel.checkUpdates();
  }
}
