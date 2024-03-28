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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Revanced Apps',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Chip(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  label: Text('BETA'),
                  backgroundColor: Colors.amber,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
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
