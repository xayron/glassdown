import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glass_down_v2/app/app.snackbar.dart';
import 'package:glass_down_v2/ui/views/apps/items/app_card/app_card.dart';
import 'package:glass_down_v2/ui/widgets/common/placeholder.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surfaceTint.withAlpha(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => viewModel.showSettings(),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
            TextButton.icon(
              onPressed: () => viewModel.showRevancedIntegration(),
              icon: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/revanced/revanced-logo-shape-light.svg'
                    : 'assets/revanced/revanced-logo-shape-dark.svg',
                height: 16,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text('Revanced'),
            ),
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
          if (viewModel.apps.isNotEmpty)
            SliverList.list(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
              ],
            )
          else
            const PlaceholderText(
              text: ['No apps 😔', 'You can add new one below!'],
            )
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
    viewModel.getLatestPatches();
    viewModel.checkUpdates();
  }
}
