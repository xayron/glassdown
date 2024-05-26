import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
                          child: FilledButton.icon(
                            onPressed: viewModel.success
                                ? () => viewModel.openApk()
                                : null,
                            icon: const Icon(Icons.install_mobile),
                            label: const Text('Install APK'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 16, 0),
                          child: FilledButton.icon(
                            onPressed:
                                viewModel.revancedExists && viewModel.success
                                    ? () => viewModel.openRevanced()
                                    : null,
                            icon: SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? viewModel.revancedExists &&
                                          viewModel.success
                                      ? 'assets/revanced/revanced-logo-shape-dark.svg'
                                      : 'assets/revanced/revanced-logo-shape-light.svg'
                                  : viewModel.revancedExists &&
                                          viewModel.success
                                      ? 'assets/revanced/revanced-logo-shape-light.svg'
                                      : 'assets/revanced/revanced-logo-shape-dark.svg',
                              height: 16,
                            ),
                            label: const Text('Open Revanced'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: FilledButton.tonalIcon(
                            onPressed: () {
                              viewModel.cancel();
                              viewModel.returnTo(home: true);
                            },
                            icon: const Icon(
                              Icons.keyboard_double_arrow_left_rounded,
                            ),
                            label: const Text('Return to app list'),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    viewModel.checkForRevancedApp();
    viewModel.checkForSai();
    viewModel.runDownload(app);
  }
}
