import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/views/download_status/items/progress_card/progress_card.dart';
import 'package:glass_down_v2/ui/views/download_status/items/status_card/status_card.dart';
import 'package:stacked/stacked.dart';

import 'download_status_viewmodel.dart';

class DownloadStatusView extends StackedView<DownloadStatusViewModel> {
  const DownloadStatusView({super.key, required this.app});

  final AppInfo app;

  @override
  Widget builder(
    BuildContext context,
    DownloadStatusViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: viewModel.canPop,
      onPopInvoked: (didPop) {
        if (!didPop) {
          viewModel.cancel();
        } else {
          viewModel.returnTo();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              expandedHeight: 90,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
                title: Text(
                  'Download',
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
            if (viewModel.hasError)
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
                          viewModel.modelError.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    surfaceTintColor: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        StatusCard(
                          title: 'Scrapping download page',
                          complete: viewModel.pageStatus.$1,
                          // subTitle: viewModel.pageStatus.$2,
                        ),
                        StatusCard(
                          title: 'Scrapping download link',
                          complete: viewModel.linkStatus.$1,
                          // subTitle: viewModel.linkStatus.$2,
                        ),
                        StatusCard(
                          title: 'Getting save path',
                          complete: viewModel.saveStatus.$1,
                          // subTitle: viewModel.saveStatus.$2,
                        ),
                        ProgressCard(
                          title: 'Downloading & saving APK',
                          complete: viewModel.apkStatus.$1 ?? true,
                          progress: viewModel.downloadProgress,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FilledButton.tonal(
                            onPressed: () {
                              viewModel.cancel();
                              viewModel.returnTo(home: true);
                            },
                            child: const Text('Return to app list'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DownloadStatusViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DownloadStatusViewModel();

  @override
  void onViewModelReady(DownloadStatusViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.runDownload(app);
  }
}
