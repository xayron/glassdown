import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/views/versions/items/version_card/version_card.dart';
import 'package:glass_down_v2/ui/widgets/common/placeholder.dart';
import 'package:stacked/stacked.dart';

import 'versions_viewmodel.dart';

class VersionsView extends StackedView<VersionsViewModel> {
  const VersionsView({super.key, required this.app});

  final AppInfo app;

  @override
  Widget builder(
    BuildContext context,
    VersionsViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) => viewModel.cancel(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => viewModel.showChangeFiltersModal(),
          icon: const Icon(Icons.edit_note),
          label: const Text('Change filters'),
        ),
        body: RefreshIndicator(
          onRefresh: () => viewModel.fetchVersions(app),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 90,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
                  title: Text(
                    app.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              if (viewModel.isBusy)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                ),
              if (viewModel.hasError && viewModel.modelError is! DioException)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          title: Text(
                            viewModel.modelError is DioException
                                ? viewModel.modelError.message
                                : viewModel.modelError.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (viewModel.appWithLinks != null)
                SliverList(
                  delegate: SliverChildListDelegate([
                    ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final appLinks in viewModel.appWithLinks!.links)
                          VersionCard(
                            app: app,
                            versionLink: appLinks,
                          )
                      ],
                    ),
                  ]),
                ),
              if (!viewModel.isBusy &&
                  viewModel.appWithLinks != null &&
                  viewModel.appWithLinks!.links.isEmpty)
                const PlaceholderText(
                  text: [
                    'No versions found',
                    'Try changing filters below',
                    'and pull to refresh results'
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  VersionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VersionsViewModel();

  @override
  void onViewModelReady(VersionsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.fetchVersions(app);
  }
}
