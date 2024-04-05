import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/views/revanced_integration/items/revanced_app_card.dart';
import 'package:glass_down_v2/ui/widgets/common/divider.dart';
import 'package:glass_down_v2/ui/widgets/common/placeholder.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/group_header.dart';
import 'package:stacked/stacked.dart';

import 'revanced_integration_model.dart';

class RevancedIntegrationView extends StackedView<RevancedIntegrationModel> {
  const RevancedIntegrationView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RevancedIntegrationModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      floatingActionButton: !viewModel.isLoading
          ? FloatingActionButton.extended(
              onPressed: () => viewModel.getLatestPatches(),
              label: Text(
                viewModel.apps.isEmpty || viewModel.unsupportedApps.isEmpty
                    ? 'Get apps'
                    : 'Refresh apps',
              ),
              icon: const Icon(Icons.download),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: Text(
              'Revanced Apps',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            automaticallyImplyLeading: true,
          ),
          if ((viewModel.apps.isEmpty || viewModel.unsupportedApps.isEmpty) &&
              !viewModel.isLoading)
            const PlaceholderText(
              text: [
                "Please tap 'Get apps' below",
                'to download list of supported apps'
              ],
            )
          else if (viewModel.isLoading)
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    clipBehavior: Clip.antiAlias,
                    surfaceTintColor: Theme.of(context).colorScheme.primary,
                    child: const ListTile(
                      leading: CircularProgressIndicator(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      title: Text('Loading apps...'),
                    ),
                  )
                ],
              ),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                ListView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 30),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const GroupHeader(name: 'Supported apps'),
                    for (final app in viewModel.apps)
                      RevancedAppCard(
                        app: app,
                        setAddingApp: viewModel.setIsAddingApp,
                        isEnabled: !viewModel.isAddingApp,
                      ),
                    const ItemDivider(indent: 4),
                    const GroupHeader(name: 'Unsupported apps'),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(6, 6, 12, 12),
                      child: Text(
                        'Apps that either not available to download from APKMirror or have restrictions when accessed outside browser',
                      ),
                    ),
                    for (final app in viewModel.unsupportedApps)
                      RevancedAppCard(
                        app: app,
                        setAddingApp: viewModel.setIsAddingApp,
                        isEnabled: !viewModel.isAddingApp,
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
  RevancedIntegrationModel viewModelBuilder(
    BuildContext context,
  ) =>
      RevancedIntegrationModel();
}
